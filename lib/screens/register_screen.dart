import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/auth_methods.dart';
import 'package:sdp_quiz_app/services/shared_pref.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class RegisterSection extends StatefulWidget {
  const RegisterSection({Key? key}) : super(key: key);

  @override
  _RegisterSectionState createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();

  bool isLoading = false;

  registerUser() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      authMethods
          .registerUser(emailController.text, passwordController.text, context)
          .then((value) {
        isLoading = false;
        setState(() {});
        if (value.isNotEmpty) {
          SharedPrefMethods.saveUserLoginState(true, value);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewUser(email: emailController.text, uid: value)));
        } else {
          SharedPrefMethods.saveUserLoginState(false, value);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fail to register"),
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
          ))
        : Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign Up To Continue",
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
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: "Confirm Password"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  ButtonLarge(
                    text: "Register",
                    onTap: () {
                      registerUser();
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
