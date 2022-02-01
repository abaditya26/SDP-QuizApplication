import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/auth_methods.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/services/shared_pref.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({Key? key}) : super(key: key);

  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  loginUser() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      authMethods
          .loginUser(emailController.text, passwordController.text, context)
          .then((value) {
        isLoading = false;
        setState(() {});
        if (value.isNotEmpty) {
          String uid = value;
          SharedPrefMethods.saveUserLoginState(true, uid);
          databaseMethods.checkIfUserExists(uid).then((value) {
            if (value) {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewUser(uid: uid, email: emailController.text)));
            }
          });
        } else {
          SharedPrefMethods.saveUserLoginState(false, value);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fail to login"),
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back",
                    style:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign In To Continue",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            return value != null
                                ? RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Enter valid email"
                                : "Email required";
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Enter your Email",
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            return value != null
                                ? value.length >= 6
                                    ? null
                                    : value.length == 0
                                        ? "Enter Password"
                                        : "Minimum password length is 6"
                                : "Enter Password";
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: "Enter Password"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  ButtonLarge(
                    text: "Login",
                    onTap: () {
                      loginUser();
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
