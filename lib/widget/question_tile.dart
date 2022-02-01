import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/questions_model.dart';
import 'package:sdp_quiz_app/screens/admin/edit_question.dart';

class QuestionTile extends StatelessWidget {
  final QuestionsModel question;
  final String quizId;

  const QuestionTile({Key? key, required this.question, required this.quizId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditQuestion(questionsModel: question, quizId: quizId)));
      },
      child: Container(
          height: MediaQuery.of(context).size.width > 800 ? 100.0 : 140.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.blueGrey[200],
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      question.question,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(question.answer)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
