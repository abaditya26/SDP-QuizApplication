import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/widget/button_lg.dart';

class QuizDetails extends StatefulWidget {
  final QuizModel quiz;

  const QuizDetails({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizDetailsState createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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

  startQuiz() {
    if (widget.quiz.isProtected) {
      if (formKey.currentState!.validate()) {
        if (passwordController.text.compareTo(widget.quiz.password) == 0) {
          //password done
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizPage(
                        quiz: widget.quiz,
                      )));
        } else {
          //password error
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Password not match.")));
        }
      }
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QuizPage(
                    quiz: widget.quiz,
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;
    double totalHeight = MediaQuery.of(context).size.height-50;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Details"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Row(
        children: [
          Spacer(),
          Container(
            width: isDesktop ? 600.0 : MediaQuery.of(context).size.width,
            height: totalHeight,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Quiz Details",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  child: Table(
                    children: [
                      getTableRow('Quiz ID', widget.quiz.quizId),
                      getTableRow('Quiz Name', widget.quiz.quizName),
                      getTableRow('Quiz Author', widget.quiz.authorName),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                if (widget.quiz.isProtected)
                  Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (val) {
                        return val == null
                            ? "Password Required"
                            : val.length == 0
                                ? "Password Required"
                                : null;
                      },
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(labelText: "Enter Password"),
                    ),
                  ),
                SizedBox(
                  height: 30.0,
                ),
                ButtonLarge(
                  text: "Attempt Quiz",
                  onTap: () {
                    startQuiz();
                  },
                )
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}