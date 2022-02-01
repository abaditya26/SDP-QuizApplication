import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/questions_model.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/screens/admin/add_question.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class ManageQuestions extends StatefulWidget {
  final QuizModel quizData;

  const ManageQuestions({Key? key, required this.quizData}) : super(key: key);

  @override
  _ManageQuestionsState createState() => _ManageQuestionsState();
}

class _ManageQuestionsState extends State<ManageQuestions> {
  List<QuestionsModel> questions = [];
  bool isLoading = false;
  DatabaseMethods databaseMethods = DatabaseMethods();

  getQuestions() {
    isLoading = true;
    setState(() {});
    databaseMethods.getAllQuestions(widget.quizData.docId).then((value) {
      QuerySnapshot snapshot = value;
      questions = [];
      snapshot.docs.forEach((doc) {
        try {
          questions.add(QuestionsModel(
              question: doc["question"],
              option1: doc["option1"],
              option2: doc["option2"],
              option3: doc["option3"],
              option4: doc["option4"],
              answer: doc["answer"],
              docId: doc.id));
        } catch (e) {}
      });
      isLoading = false;
      setState(() {});
    });
  }

  getTableRow(String title, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          value,
          style: TextStyle(fontSize: 20.0),
        ),
      )
    ]);
  }

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Manage Quiz"),
              centerTitle: true,
              elevation: 0.0,
              actions: [
                IconButton(
                  onPressed: () {
                    getQuestions();
                  },
                  icon: Icon(Icons.refresh),
                ),
                SizedBox(width: 10.0,),
                if (isDesktop)
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddQuestion(
                                quizData: widget.quizData,
                              ))).then((value) {
                        getQuestions();
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                SizedBox(width: 10.0,)
              ],
            ),
            floatingActionButton: isDesktop
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddQuestion(
                                    quizData: widget.quizData,
                                  ))).then((value) {
                        getQuestions();
                      });
                    },
                    child: Icon(Icons.add),
                  ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    width:
                        isDesktop ? 600.0 : MediaQuery.of(context).size.width,
                    child: Table(
                      children: [
                        getTableRow("Quiz ID", widget.quizData.quizId),
                        getTableRow("Quiz Name", widget.quizData.quizName),
                        if (widget.quizData.isProtected)
                          getTableRow("Quiz Password", widget.quizData.password)
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Expanded(
                    child: questions.length == 0
                        ? Center(
                            child: Text(
                              "No Questions...",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0)),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return QuestionTile(
                                    question: questions[index],
                                    quizId: widget.quizData.docId,
                                  );
                                },
                                itemCount: questions.length,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
