import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';

class AttemptedScore extends StatefulWidget {
  final QuizModel quiz;

  const AttemptedScore({Key? key, required this.quiz}) : super(key: key);

  @override
  _AttemptedScoreState createState() => _AttemptedScoreState();
}

class _AttemptedScoreState extends State<AttemptedScore> {
  int total = 0;
  bool isLoading = true;
  int scored = 0;
  final DatabaseMethods databaseMethods = DatabaseMethods();

  getData() {
    isLoading = true;
    setState(() {});
    databaseMethods.getAttemptedScore(widget.quiz.docId).then((snapshot) {
      snapshot.docs.forEach((doc) {
        try {
          total++;
          bool isCorrect = doc["correct"];
          print(isCorrect);
          if (isCorrect) {
            scored++;
          }
        } catch (e) {}
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/quizback.png"),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if (isDesktop) Spacer(),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      width: isDesktop
                          ? 600.0
                          : MediaQuery.of(context).size.width - 40,
                      height: isDesktop
                          ? 600.0
                          : MediaQuery.of(context).size.height - 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Color(0X99FFFFFF),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100.0,
                                ),
                                Text(
                                  widget.quiz.quizName,
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Text(
                                  "$scored/$total",
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 100.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isDesktop) Spacer(),
                  ],
                ),
              ),
            ),
          );
  }
}
