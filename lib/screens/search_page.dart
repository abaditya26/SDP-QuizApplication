import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/quiz_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late QuizModel quiz;
  bool isLoading = false;
  bool isLoaded = false;
  bool noQuiz = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController quizId = TextEditingController();
  final formKey = GlobalKey<FormState>();

  searchQuiz() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      isLoaded = false;
      noQuiz = false;
      setState(() {});

      databaseMethods.getQuizById(quizId.text).then((value) {
        QuerySnapshot snapshot = value;
        if (snapshot.docs.length == 0) {
          noQuiz = true;
          isLoading = false;
          isLoaded = false;
          setState(() {});
          return;
        }
        final doc = snapshot.docs[0];
        quiz = QuizModel(
            quizId: doc["quizId"],
            quizName: doc["quizName"],
            password: doc["password"],
            isProtected: doc["isProtected"],
            image: doc["image"],
            authorId: doc["authorId"],
            authorName: doc["authorName"],
            docId: doc.id);
        isLoading = false;
        isLoaded = true;
        setState(() {});
      });
    }
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
            appBar: AppBar(
              title: Text("Search Quiz"),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          validator: (value) {
                            return value == null
                                ? "Enter quiz ID"
                                : value.length == 0
                                    ? "Enter Quiz ID"
                                    : null;
                          },
                          controller: quizId,
                          decoration:
                              InputDecoration(hintText: "Enter Quiz ID"),
                        )),
                        IconButton(
                          onPressed: () {
                            searchQuiz();
                          },
                          icon: Icon(Icons.search),
                        ),
                      ],
                    ),
                    isLoaded
                        ? Container(
                            child: Column(
                              children: [
                                QuizTile(
                                  index: 0,
                                  quiz: quiz,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    if (noQuiz)
                      Expanded(
                        child: Center(
                          child: Text(
                            "No Quiz Found with this ID",
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
  }
}
