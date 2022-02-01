import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/screens/register_screen.dart';

import 'login_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final isDesktop = screenSize.width > 800;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isDesktop ? 500.0 : MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120.0,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!isLogin) {
                          isLogin = true;
                          setState(() {});
                        }
                      },
                      child: Text(
                        "Login",
                        style: isLogin
                            ? TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)
                            : TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        if (isLogin) {
                          isLogin = false;
                          setState(() {});
                        }
                      },
                      child: Text(
                        "Register",
                        style: isLogin
                            ? TextStyle(fontSize: 18.0)
                            : TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                isLogin ? LoginSection() : RegisterSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
