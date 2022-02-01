import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/models/user_questions.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';

class QuizPage extends StatefulWidget {
  final QuizModel quiz;

  const QuizPage({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<UserQuestionsModel> questions = [];
  bool isLoading = false;
  DatabaseMethods databaseMethods = DatabaseMethods();

  int index = 0;

  getData() {
    isLoading = true;
    setState(() {});
    databaseMethods.getQuestionsById(widget.quiz.docId).then((snapshot) {
      questions = [];
      snapshot.docs.forEach((doc) {
        try {
          questions.add(UserQuestionsModel(
            question: doc["question"],
            option1: doc["option1"],
            option2: doc["option2"],
            option3: doc["option3"],
            option4: doc["option4"],
            answer: doc["answer"],
            docId: doc.id,
            selected: '',
          ));
        } catch (e) {}
      });
      isLoading = false;
      setState(() {});
    });
  }

  optionSection(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          questions[index].selected = value;
        });
      },
      child: Row(
        children: [
          Radio(
              value: value,
              groupValue: questions[index].selected,
              onChanged: (val) {
                setState(() {
                  questions[index].selected = value;
                });
              }),
          Expanded(
            child: Text(
              value,
            ),
          )
        ],
      ),
    );
  }

  changeButton(String text, onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  saveData() {
    databaseMethods.saveQuiz(widget.quiz, questions);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QuizScoreScreen(quiz: widget.quiz, questions: questions)));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0XFF8EB8FF),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                saveData();
              },
              child: Icon(Icons.done),
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/quizback.png")),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width > 1200
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.quiz.quizName,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Text(
                              "Question no. ${index + 1}/${questions.length}",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                            Container(
                              margin: EdgeInsets.all(15.0),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: Form(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      questions[index].question,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    optionSection(questions[index].option1),
                                    optionSection(questions[index].option2),
                                    optionSection(questions[index].option3),
                                    optionSection(questions[index].option4),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    changeButton("PREV", () {
                                      index--;
                                      if (index < 0) {
                                        index = questions.length - 1;
                                      }
                                    }),
                                    changeButton("NEXT", () {
                                      index++;
                                      if (index == questions.length) {
                                        index = 0;
                                      }
                                    }),
                                  ]),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
  }
}
