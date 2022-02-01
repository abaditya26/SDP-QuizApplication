import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/user_model.dart';
import 'package:sdp_quiz_app/services/data.dart';
import 'package:sdp_quiz_app/services/database_methods.dart';
import 'package:sdp_quiz_app/widget/button_lg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  UserModel userData = UserData.userData;
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final DatabaseMethods databaseMethods = DatabaseMethods();

  updateProfile() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      String name = nameController.text;
      String phone = phoneController.text;
      if (userData.name.compareTo(name) == 0 &&
          userData.phone.compareTo(phone) == 0) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No changes made.")));
      } else {
        UserModel user = UserModel(
            uid: userData.uid,
            name: name,
            email: userData.email,
            phone: phone,
            image: userData.image,
            isAdmin: userData.isAdmin);
        userData = user;
        databaseMethods.updateProfile(user).then((value) {
          UserData.userData = user;
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("User data updated!")));
          setState(() {});
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    nameController.text = userData.name;
    phoneController.text = userData.phone;
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
            body: SafeArea(
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width > 800.0
                        ? 800.0
                        : MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Your Profile",
                                      style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Hero(
                                      tag: "profile_image",
                                      child: userData.image.compareTo("default") == 0
                                          ? CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: AssetImage(
                                                  "assets/images/user-icon.png"),
                                            )
                                          : CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage:
                                                  NetworkImage(userData.image),
                                            ),
                                    ),
                                    Positioned(
                                      child: CircleAvatar(
                                        child: Icon(Icons.edit),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      bottom: 0,
                                      right: 0,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            userData.email,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Form(
                            key: formKey,
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration:
                                        InputDecoration(labelText: "Your Name"),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    controller: phoneController,
                                    decoration:
                                        InputDecoration(labelText: "Your Phone No."),
                                  ),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  ButtonLarge(
                                      text: "Update Profile",
                                      onTap: () {
                                        updateProfile();
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
          );
  }
}
