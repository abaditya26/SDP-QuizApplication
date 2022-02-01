import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/models/user_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/auth_methods.dart';
import 'package:sdp_quiz_app/services/data.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/services/shared_pref.dart';
import 'package:sdp_quiz_app/widget/dashboard_widgets/dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthMethods authMethods = AuthMethods();

  bool isDesktop = false;

  DatabaseMethods databaseMethods = DatabaseMethods();
  late UserModel userData;
  bool isLoading = true;
  int createdQuizzes = 0;

  List<QuizModel> quizzes = [];

  getData() {
    isLoading = true;
    setState(() {});
    SharedPrefMethods.isLogin().then((value) {
      if (value.isNotEmpty) {
        String uid = value;
        print(uid);
        databaseMethods.getUserData(uid).then((value) {
          print("in");
          QuerySnapshot snapshot = value;
          String uid = snapshot.docs[0]["uid"];
          String name = snapshot.docs[0]["name"];
          String email = snapshot.docs[0]["email"];
          String image = snapshot.docs[0]["image"];
          String phone = snapshot.docs[0]["phone"];
          bool isAdmin = snapshot.docs[0]["isAdmin"];
          userData = UserModel(
            uid: uid,
            name: name,
            email: email,
            phone: phone,
            image: image,
            isAdmin: isAdmin,
          );
          UserData.userData = userData;
          getAttempted();
        }).catchError((e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          authMethods.signOut(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User details not loaded...")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        authMethods.signOut(context);
      }
    });
  }

  getAttempted() {
    databaseMethods.getAttemptedQuizzes(UserData.uid).then((snapshot) {
      snapshot.docs.forEach((doc) {
        try {
          quizzes.add(QuizModel(
              quizId: doc["quizId"],
              quizName: doc["quizName"],
              password: doc["password"],
              isProtected: doc["isProtected"],
              image: doc["image"],
              authorId: doc["authorId"],
              authorName: doc["authorName"],
              docId: doc.id));
        } catch (e) {}
      });
      if (userData.isAdmin) {
        databaseMethods.getAdminQuizzes(userData.uid).then((snapshot) {
          createdQuizzes = snapshot.docs.length;
          isLoading = false;
          setState(() {});
        });
      } else {
        isLoading = false;
        setState(() {});
      }
    });
  }

  Widget attemptedQuizAndLogOut() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Attempted :- ",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "${quizzes.length}",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          )),
          IconButton(
            onPressed: () {
              authMethods.signOut(context);
            },
            iconSize: 30.0,
            color: Colors.red,
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }

  Widget manageAdminQuiz() {
    return Column(
      children: [
        Divider(
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Quizzes :- ",
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "$createdQuizzes",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              )),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ManageQuizzes()));
                },
                iconSize: 30.0,
                color: Colors.white,
                icon: Icon(Icons.settings),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    isDesktop = screenSize.width > 800;

    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.black54,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          UserInfo(userData: userData),
                          Divider(
                            color: Colors.white,
                          ),
                          attemptedQuizAndLogOut(),
                          userData.isAdmin
                              ? manageAdminQuiz()
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    AttemptedQuiz(quizzes: quizzes),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllQuizzesScreen(),
                  ),
                );
              },
            ),
          );
  }
}
