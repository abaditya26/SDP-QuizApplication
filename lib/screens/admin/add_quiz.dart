import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/services/data.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/button_lg.dart';

class AddQuizScreen extends StatefulWidget {
  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  bool _isProtected = false;
  bool isLoading = false;

  TextEditingController quizIdController = TextEditingController();
  TextEditingController quizNameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = DatabaseMethods();

  addQuiz() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      String quizId = quizIdController.text;
      String quizName = quizNameController.text;
      String password = passwordController.text;
      String image = imageController.text;
      String authorName = UserData.userData.name;
      String authorId = UserData.userData.uid;
      bool isProtected = _isProtected;

      QuizModel quiz = QuizModel(
          quizId: quizId,
          quizName: quizName,
          password: password,
          isProtected: isProtected,
          image: image,
          authorId: authorId,
          authorName: authorName,
          docId: "");
      databaseMethods.checkQuizId(context, quizId).then((value) {
        if (value) {
          databaseMethods.addQuizData(context, quiz);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Quiz ID unavailable choose other.")));
          isLoading = false;
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("New Quiz"),
        elevation: 0.0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                  child: Container(
                width: MediaQuery.of(context).size.width > 800
                    ? 800
                    : MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      "Create New Quiz",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value == null
                                  ? "Enter Quiz Name"
                                  : value.length <= 6
                                      ? "Minimum quiz name length is 6."
                                      : null;
                            },
                            controller: quizNameController,
                            decoration:
                                InputDecoration(labelText: "Enter Quiz Name"),
                          ),
                          TextFormField(
                            validator: (value) {
                              return value == null
                                  ? "Enter Quiz ID"
                                  : value.length < 6
                                      ? "Minimum quiz ID length is 6."
                                      : null;
                            },
                            controller: quizIdController,
                            decoration: InputDecoration(
                              labelText: "Enter Quiz ID",
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Make Quiz Private?",
                            style: TextStyle(),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ListTile(
                            title: const Text('Yes'),
                            leading: Radio(
                              value: true,
                              groupValue: _isProtected,
                              onChanged: (value) {
                                setState(() {
                                  _isProtected = true;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('No'),
                            leading: Radio(
                              value: false,
                              groupValue: _isProtected,
                              onChanged: (value) {
                                setState(() {
                                  _isProtected = false;
                                });
                              },
                            ),
                          ),
                          _isProtected
                              ? TextFormField(
                                  validator: (value) {
                                    return value == null
                                        ? "Enter Quiz Password"
                                        : value.length < 6
                                            ? "Minimum quiz Password length is 6."
                                            : null;
                                  },
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      labelText: "Enter Quiz Password"),
                                )
                              : SizedBox.shrink(),
                          TextFormField(
                            validator: (value) {
                              return value != null
                                  ? value.contains("http") &&
                                          value.contains(".")
                                      ? null
                                      : "Invalid URL"
                                  : "URL required";
                            },
                            controller: imageController,
                            decoration: InputDecoration(
                                labelText: "Enter Quiz title image URL"),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ButtonLarge(
                              text: "Create Quiz",
                              onTap: () {
                                addQuiz();
                              })
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ),
    );
  }
}
