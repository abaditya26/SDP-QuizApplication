import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/user_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';
import 'package:sdp_quiz_app/services/auth_methods.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class NewUser extends StatefulWidget {
  final String uid;
  final String email;

  const NewUser({Key? key, required this.uid, required this.email})
      : super(key: key);

  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = DatabaseMethods();

  saveUserData() {
    isLoading = true;
    setState(() {});
    UserModel userModel = UserModel(
      uid: widget.uid,
      name: nameController.text,
      email: widget.email,
      phone: phoneController.text,
      image: "default",
      isAdmin: false,
    );
    databaseMethods.addNewUser(userModel, context).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false);
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      isLoading = false;
      setState(() {});
    });
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AuthMethods().signOut(context);
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.exit_to_app),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120.0,
                    ),
                    Text(
                      "New User",
                      style: TextStyle(
                          fontSize: 34.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Fill below details to complete registration",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Positioned(
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage:
                                  AssetImage("assets/images/user-icon.png"),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                Icons.edit_outlined,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "${widget.email}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              return value != null
                                  ? value.length >= 6
                                      ? null
                                      : value.length == 0
                                          ? "Enter Name"
                                          : "Minimum name length is 6"
                                  : "Enter Name";
                            },
                            decoration: InputDecoration(
                              labelText: "Enter your Name",
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                                labelText: "Enter Your Phone Number"),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    ButtonLarge(
                      text: "Register User",
                      onTap: () {
                        saveUserData();
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
