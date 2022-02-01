import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/data.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';

class ManageQuizzes extends StatefulWidget {
  @override
  _ManageQuizzesState createState() => _ManageQuizzesState();
}

class _ManageQuizzesState extends State<ManageQuizzes> {
  bool isLoading = false;
  List<QuizModel> quizzes = [];

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    getQuizzes();
  }

  getQuizzes() {
    isLoading = true;
    setState(() {});
    quizzes = [];
    String uid = UserData.userData.uid;
    databaseMethods.getAdminQuizzes(uid).then((value) {
      QuerySnapshot snapshot = value;
      snapshot.docs.forEach((doc) {
        quizzes.add(QuizModel(
            quizId: doc["quizId"],
            quizName: doc["quizName"],
            password: doc["password"],
            isProtected: doc["isProtected"],
            image: doc["image"],
            authorId: doc["authorId"],
            authorName: doc["authorName"],
            docId: doc.id));
      });
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Manage Quizzes"),
              elevation: 0.0,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    getQuizzes();
                  },
                  icon: Icon(Icons.refresh),
                ),
                SizedBox(
                  width: 20.0,
                ),
                if (isDesktop)
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuizScreen(),
                        ),
                      );
                    },
                  ),
                SizedBox(
                  width: 20.0,
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: GridView.builder(
                itemCount: quizzes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 1000
                      ? 3
                      : MediaQuery.of(context).size.width > 600
                          ? 2
                          : 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: (2 / 1),
                ),
                itemBuilder: (
                  context,
                  index,
                ) {
                  return _AdminQuizTile(
                    quiz: quizzes[index],
                  );
                },
              ),
            ),
            floatingActionButton: isDesktop
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddQuizScreen()));
                    },
                    child: Icon(Icons.add),
                  ),
          );
  }
}

class _AdminQuizTile extends StatelessWidget {
  final QuizModel quiz;

  const _AdminQuizTile({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ManageQuestions(
                      quizData: quiz,
                    )));
      },
      child: Container(
          height: 140.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.red[100],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  quiz.isProtected ? Icon(Icons.lock) : SizedBox.shrink(),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            quiz.quizName,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(quiz.quizId)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          )),
    );
  }
}
