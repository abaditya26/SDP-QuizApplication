import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class AllQuizzesScreen extends StatefulWidget {
  const AllQuizzesScreen({Key? key}) : super(key: key);

  @override
  _AllQuizzesScreenState createState() => _AllQuizzesScreenState();
}

class _AllQuizzesScreenState extends State<AllQuizzesScreen> {
  bool isLoading = false;
  List<QuizModel> quizzes = [];

  DatabaseMethods databaseMethods = DatabaseMethods();

  getAllQuizzes() {
    isLoading = true;
    setState(() {});
    databaseMethods.getAllQuizzes().then((value) {
      QuerySnapshot snapshot = value;
      quizzes = [];
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
    });
  }

  @override
  void initState() {
    super.initState();
    getAllQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final isDesktop = screenSize.width > 800;
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Recently added quizzes",
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      getAllQuizzes();
                    },
                    icon: Icon(Icons.refresh)),
                SizedBox(width: 10.0,),
                if (isDesktop)
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                    ),
                  ),
                SizedBox(width: 10.0,)
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: isDesktop
                        ? GridView.builder(
                            itemCount: quizzes.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 1000
                                      ? 3
                                      : 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: (2 / 1),
                            ),
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return QuizTile(
                                index: index,
                                quiz: quizzes[index],
                              );
                            },
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              return QuizTile(
                                index: index,
                                quiz: quizzes[index],
                              );
                            },
                            itemCount: quizzes.length,
                          ),
                  ),
                ),
              ],
            ),
            floatingActionButton: isDesktop
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                    child: Icon(Icons.search),
                  ),
          );
  }
}
