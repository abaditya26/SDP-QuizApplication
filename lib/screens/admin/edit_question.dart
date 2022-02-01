import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/questions_model.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class EditQuestion extends StatefulWidget {
  final QuestionsModel questionsModel;
  final String quizId;

  const EditQuestion(
      {Key? key, required this.questionsModel, required this.quizId})
      : super(key: key);

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  bool isLoading = false;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();
  TextEditingController selected = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = DatabaseMethods();

  updateQuestion() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
    }
    QuestionsModel questionsModel = QuestionsModel(
        question: questionController.text,
        option1: option1Controller.text,
        option2: option2Controller.text,
        option3: option3Controller.text,
        option4: option4Controller.text,
        answer: selected.text,
        docId: widget.questionsModel.docId);
    databaseMethods.updateQuestion(widget.quizId, questionsModel).then((value) {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update success")));
    });
  }

  deleteQuestion() {
    isLoading = true;
    setState(() {});
    databaseMethods
        .deleteQuestion(widget.questionsModel.docId, widget.quizId)
        .then((value) {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Question Deleted.")));
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    questionController.text = widget.questionsModel.question;
    option1Controller.text = widget.questionsModel.option1;
    option2Controller.text = widget.questionsModel.option2;
    option3Controller.text = widget.questionsModel.option3;
    option4Controller.text = widget.questionsModel.option4;
    if (widget.questionsModel.answer.compareTo(widget.questionsModel.option1) ==
        0) {
      selected = option1Controller;
    } else if (widget.questionsModel.answer
            .compareTo(widget.questionsModel.option2) ==
        0) {
      selected = option2Controller;
    } else if (widget.questionsModel.answer
            .compareTo(widget.questionsModel.option3) ==
        0) {
      selected = option3Controller;
    } else if (widget.questionsModel.answer
            .compareTo(widget.questionsModel.option4) ==
        0) {
      selected = option4Controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Question"),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outlined,
              color: Colors.red,
            ),
            onPressed: () {
              deleteQuestion();
            },
          ),
          SizedBox(
            width: 10.0,
          )
        ],
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
                          "Edit Question",
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
                          decoration: InputDecoration(labelText: "Question"),
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
                                decoration:
                                    InputDecoration(labelText: "Option 1"),
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
                                decoration:
                                    InputDecoration(labelText: "Option 2"),
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
                                decoration:
                                    InputDecoration(labelText: "Option 3"),
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
                                decoration:
                                    InputDecoration(labelText: "Option 4"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ButtonLarge(
                            text: "Update Question",
                            onTap: () {
                              updateQuestion();
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
