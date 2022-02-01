import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/questions_model.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/button_lg.dart';

class AddQuestion extends StatefulWidget {
  final QuizModel quizData;

  const AddQuestion({Key? key, required this.quizData}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  bool isLoading = false;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();
  TextEditingController selected = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = DatabaseMethods();

  addQuestion() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      QuestionsModel question = QuestionsModel(
          question: questionController.text,
          option1: option1Controller.text,
          option2: option2Controller.text,
          option3: option3Controller.text,
          option4: option4Controller.text,
          answer: selected.text,
          docId: "");
      databaseMethods
          .addQuestion(question, widget.quizData.docId)
          .then((value) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Question Added.")));
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width > 1000.0
                      ? 1000.0
                      : MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          "Add Question",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        TextFormField(
                          validator: (value) {
                            return value == null || value.length == 0
                                ? "Enter Question"
                                : null;
                          },
                          controller: questionController,
                          decoration:
                              InputDecoration(labelText: "Enter Question"),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: option1Controller,
                              groupValue: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = option1Controller;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  return value == null || value.length == 0
                                      ? "Enter Option"
                                      : null;
                                },
                                controller: option1Controller,
                                decoration: InputDecoration(
                                    labelText: "Enter Option 1"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: option2Controller,
                              groupValue: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = option2Controller;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  return value == null || value.length == 0
                                      ? "Enter Option"
                                      : null;
                                },
                                controller: option2Controller,
                                decoration: InputDecoration(
                                    labelText: "Enter Option 2"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: option3Controller,
                              groupValue: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = option3Controller;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  return value == null || value.length == 0
                                      ? "Enter Option"
                                      : null;
                                },
                                controller: option3Controller,
                                decoration: InputDecoration(
                                    labelText: "Enter Option 3"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: option4Controller,
                              groupValue: selected,
                              onChanged: (value) {
                                setState(() {
                                  selected = option4Controller;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  return value == null || value.length == 0
                                      ? "Enter Option"
                                      : null;
                                },
                                controller: option4Controller,
                                decoration: InputDecoration(
                                    labelText: "Enter Option 4"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ButtonLarge(
                            text: "Add Question",
                            onTap: () {
                              addQuestion();
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
