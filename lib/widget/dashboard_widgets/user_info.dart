import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/user_model.dart';
import 'package:sdp_quiz_app/screens/screens.dart';

class UserInfo extends StatelessWidget {
  final UserModel userData;

  const UserInfo({Key? key, required this.userData}) : super(key: key);

  getMobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome,",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userData.name,
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        userData.email,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Hero(
              tag: "profile_image",
              child: userData.image.compareTo("default") == 0
                  ? CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          AssetImage("assets/images/user-icon.png"),
                    )
                  : CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(userData.image),
                    ),
            ),
          )
        ],
      ),
    );
  }

  getDesktopView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Quiz Application",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: Text(
                      "Welcome, ${userData.name}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Hero(
              tag: "profile_image",
              child: userData.image.compareTo("default") == 0
                  ? CircleAvatar(
                      radius: 22.0,
                      backgroundImage:
                          AssetImage("assets/images/user-icon.png"),
                    )
                  : CircleAvatar(
                      radius: 22.0,
                      backgroundImage: NetworkImage(userData.image),
                    ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final isDesktop = screenSize.width > 800;

    return isDesktop ? getDesktopView(context) : getMobileView(context);
  }
}
