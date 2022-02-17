import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/models/score_question_model.dart';
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
    for (var que in widget.questions) {
      if (que.answer.compareTo(que.selected) == 0) {
        scored++;
      }
    }
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
                          Expanded(
                            child: ListView.builder(itemBuilder: (context, index){
                              UserQuestionsModel uQue = widget.questions[index];
                              ScoreQuestionModel que = ScoreQuestionModel(answer: uQue.answer,
                                  question: uQue.question, selected: uQue.selected, correct: uQue.answer==uQue.selected);
                              return _Question(que:que, index:index);
                            }, itemCount: widget.questions.length,),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if(isDesktop)
                const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}


class _Question extends StatelessWidget {
  final ScoreQuestionModel que;
  final int index;

  const _Question({Key? key, required this.que, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      height: 150.0,
      decoration: BoxDecoration(
        color: que.correct ? Color(0X4C00FF00) :Color(0x4CFF0000),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Spacer(),
          Text(que.question,style: TextStyle(fontSize: 20.0),),
          if(!que.correct)
            Text(que.selected, textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF650000)),),
          Text("Ans :- ${que.answer}", textAlign: TextAlign.center,),
          Spacer(),
        ],
      ),
    );
  }
}


