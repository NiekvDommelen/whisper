import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'userdata.dart';

userdata Userdata = userdata(0, "", "");
api Api = api();

void setup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool('loggedIn') ?? false ){
    var userid = prefs.getInt('userid') ?? 0;
    var userdata = await Api.searchUserData(userid);
    Userdata.username = userdata["username"];
    Userdata.email = userdata["email"];
    Userdata.userid = userdata["id"];
  }
}