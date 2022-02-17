import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/questions_model.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/models/user_model.dart';
import 'package:sdp_quiz_app/models/user_questions.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/data.dart';

class DatabaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNewUser(UserModel userData, BuildContext context) async {
    try {
      return await firestore.collection("users").doc(userData.uid).set({
        "uid": userData.uid,
        "email": userData.email,
        "name": userData.name,
        "image": userData.image,
        "phone": userData.phone,
        "isAdmin": userData.isAdmin
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<QuerySnapshot> getUserData(String uid) async {
    return await firestore
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();
  }

  Future<bool> checkIfUserExists(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection("users").doc(uid).get();
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }

  addQuizData(BuildContext context, QuizModel quiz) {
    firestore.collection("quizzes").add({
      "authorId": quiz.authorId,
      "authorName": quiz.authorName,
      "image": quiz.image,
      "isProtected": quiz.isProtected,
      "password": quiz.password,
      "quizId": quiz.quizId,
      "quizName": quiz.quizName,
    }).then((value) {
      //quiz added
      quiz.docId = value.id;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ManageQuestions(
                    quizData: quiz,
                  )));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  Future<bool> checkQuizId(BuildContext context, String quizId) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection("quizzes").doc(quizId).get();
      return !snapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot<Object?>> getAdminQuizzes(String uid) async {
    return await firestore
        .collection("quizzes")
        .where("authorId", isEqualTo: uid)
        .get();
  }

  Future<QuerySnapshot<Object?>> getAllQuizzes() async {
    return await firestore.collection("quizzes").limit(20).get();
  }

  Future<QuerySnapshot> getQuizById(String quizId) async {
    return await firestore
        .collection("quizzes")
        .where("quizId", isEqualTo: quizId)
        .get();
  }

  Future<void> updateProfile(UserModel user) async {
    return await firestore.collection("users").doc(user.uid).update({
      "name": user.name,
      "phone": user.phone,
    });
  }

  Future<QuerySnapshot<Object?>> getAllQuestions(String quizId) async {
    return await firestore
        .collection("quizzes")
        .doc(quizId)
        .collection("questions")
        .get();
  }

  Future<DocumentReference> addQuestion(
      QuestionsModel question, String docId) async {
    return await firestore
        .collection("quizzes")
        .doc(docId)
        .collection("questions")
        .add({
      "question": question.question,
      "answer": question.answer,
      "option1": question.option1,
      "option2": question.option2,
      "option3": question.option3,
      "option4": question.option4,
    });
  }

  Future<void> updateQuestion(String quizId, QuestionsModel question) async {
    return await firestore
        .collection("quizzes")
        .doc(quizId)
        .collection("questions")
        .doc(question.docId)
        .update({
      "question": question.question,
      "answer": question.answer,
      "option1": question.option1,
      "option2": question.option2,
      "option3": question.option3,
      "option4": question.option4,
    });
  }

  Future<void> deleteQuestion(String questionId, String quizId) async {
    return await firestore
        .collection("quizzes")
        .doc(quizId)
        .collection("questions")
        .doc(questionId)
        .set({});
  }

  Future<QuerySnapshot<Object?>> getQuestionsById(String quizId) async {
    return await firestore
        .collection("quizzes")
        .doc(quizId)
        .collection("questions")
        .get();
  }

  void saveQuiz(QuizModel quiz, List<UserQuestionsModel> questions) {
    String uid = UserData.userData.uid;
    firestore
        .collection("users")
        .doc(uid)
        .collection("attempted_quizzes")
        .doc(quiz.docId)
        .set({
      "authorId": quiz.authorId,
      "authorName": quiz.authorName,
      "image": quiz.image,
      "isProtected": quiz.isProtected,
      "password": quiz.password,
      "quizId": quiz.quizId,
      "quizName": quiz.quizName,
    });
    for (var question in questions) {
      bool isCorrect = question.selected.compareTo(question.answer) == 0;
      firestore
          .collection("users")
          .doc(uid)
          .collection("attempted_quizzes")
          .doc(quiz.docId)
          .collection("questions")
          .doc(question.docId)
          .set({
        "question": question.question,
        "answer": question.answer,
        "selected": question.selected,
        "correct": isCorrect,
      });
    }
  }

  Future<QuerySnapshot<Object?>> getAttemptedQuizzes(String uid) async {
    return await firestore
        .collection("users")
        .doc(uid)
        .collection("attempted_quizzes")
        .get();
  }

  Future<QuerySnapshot<Object?>> getAttemptedScore(String quizId) async {
    return await firestore
        .collection("users")
        .doc(UserData.uid)
        .collection("attempted_quizzes")
        .doc(quizId)
        .collection("questions")
        .get();
  }
}
