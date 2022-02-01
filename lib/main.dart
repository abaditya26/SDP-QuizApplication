import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/shared_pref.dart';

import 'services/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    SharedPrefMethods.isLogin().then((value) {
      isLoading = false;
      if (value.isNotEmpty) {
        isLogin = true;
        UserData.uid = value;
      }
      setState(() {});
    });

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: isLoading
          ? Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : isLogin
          ? DashboardScreen()
          : HomePage(),
    );
  }
}
