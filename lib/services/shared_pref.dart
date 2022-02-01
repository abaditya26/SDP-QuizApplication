import 'package:sdp_quiz_app/services/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefMethods {
  static String LOGIN_STATE_KEY = "USERLOGINSTATE";
  static String USER_ID_KEY = "USERIDKEY";

  static saveUserLoginState(bool loginState, String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(LOGIN_STATE_KEY, loginState);
    sharedPreferences.setString(USER_ID_KEY, uid);
    UserData.uid = uid;
  }

  static Future<String> isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool(LOGIN_STATE_KEY) ?? false) {
      return sharedPreferences.getString(USER_ID_KEY) ?? "";
    } else {
      return "";
    }
  }
}
