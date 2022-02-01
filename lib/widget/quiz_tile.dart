import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';

class QuizTile extends StatelessWidget {
  final int index;
  final QuizModel quiz;
  final bool isAttempted;

  const QuizTile(
      {Key? key,
      required this.index,
      required this.quiz,
      this.isAttempted = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isAttempted
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttemptedScore(quiz: quiz)))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizDetails(
                    quiz: quiz,
                  ),
                ),
              );
      },
      child: Container(
          height: 140.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: index % 2 == 0 ? Colors.blueGrey[200] : Colors.red[100],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  quiz.isProtected
                      ? Icon(Icons.lock)
                      : SizedBox(
                          height: 20.0,
                        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text("Author:- ${quiz.authorName}")],
              ),
            ],
          )),
    );
  }
}
