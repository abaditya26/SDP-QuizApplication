import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/models/user_questions.dart';

class QuizScoreScreen extends StatefulWidget {
  final QuizModel quiz;
  final List<UserQuestionsModel> questions;

  const QuizScoreScreen({Key? key, required this.quiz, required this.questions})
      : super(key: key);

  @override
  _QuizScoreScreenState createState() => _QuizScoreScreenState();
}

class _QuizScoreScreenState extends State<QuizScoreScreen> {
  int total = 0;
  int scored = 0;

  calculateScore() {
    total = widget.questions.length;
    widget.questions.forEach((que) {
      if (que.answer.compareTo(que.selected) == 0) {
        scored++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    calculateScore();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width>600;
    return Scaffold(
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
              if(isDesktop)
                Spacer(),
              Container(
                margin: EdgeInsets.all(20.0),
                width: isDesktop ? 600.0 : MediaQuery.of(context).size.width-40,
                height: isDesktop ? 600.0 : MediaQuery.of(context).size.height-40,
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
                        style:
                            TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        "$scored/$total",
                        style:
                            TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
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
              if(isDesktop)
                Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
