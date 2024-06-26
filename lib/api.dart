import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/userdata.dart';

class api{
  static const String _baseURL = "http://10.59.138.18:3000/api/";


  api();
  // ____DEBUG____
  Future<dynamic> debugApiData() async {
    var userdata = await getUserData();
    var data = {"_baseURL": _baseURL, "Userid": userdata["id"], "Username": userdata["username"], "Email": userdata["email"]};
    return data;
  }
  // ____END DEBUG____

  // void setUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   debugPrint('Logged in: ${prefs.getBool('loggedIn') ?? false}');
  //   if(prefs.getBool('loggedIn') ?? false == false){
  //     return;
  //   }
  //   var data = await getUserData();
  //   Userdata.userid = data["id"];
  //   Userdata.username = data["username"];
  //   Userdata.email = data["email"];
  //   userdata(Userdata.userid, Userdata.username, Userdata.email);
  // }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userid = prefs.getInt("userid") ?? 0;
    return userid;
  }

  Future<dynamic> searchUserData(userid) async {
    String address = "${_baseURL}user";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
      },
    );

    if(response.body.isNotEmpty) {
      var $data = jsonDecode(response.body);
      return $data;
    }else{
      return null;
    }
  }

  Future<dynamic> getUserData() async {
    int userid = await getUserId();
    String address = "${_baseURL}user";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
      },
    );

    if(response.body.isNotEmpty) {
      var $data = jsonDecode(response.body);
      return $data;
    }else{
      return null;
    }

  }

  Future<bool> loginUser(String username, String password) async{
    String address = "${_baseURL}login";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'username': username,
        'password': password,
      },
    );
    var $data = jsonDecode(response.body);
    if($data["success"] == true){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true);
      prefs.setInt('userid', $data["userid"]);
      return true;
    }else{
      return false;
    }
  }

  Future<dynamic> signupUser(String username, String email, String password) async {
    String address = "${_baseURL}signup";
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    var $data = jsonDecode(response.body);
    if($data["success"]?? false == true){
      bool login = await loginUser(username, password);
      if(login){
        return $data;
      }else{
        return {"success": false};
      }

    }else{
      return $data;
    }
  }

  //TODO: fix this shijt!!
  void _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    //TODO: clear userdata
  }

  Future<dynamic> searchUsers(String search) async {
    String address = "${_baseURL}users";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'query': search,
      },
    );
    var $data = [];
    if(response.body.isNotEmpty) {
      $data = jsonDecode(response.body);
    }
    return $data;
  }

  Future<dynamic> getContacts() async {
    int userid = await getUserId();
    String address = "${_baseURL}contacts";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
      },
    );
    var $data = [];
    if(response.body.isNotEmpty) {
      $data = jsonDecode(response.body);
    }
    return $data;
  }

  Future<bool> addContact(contactid) async {
    int userid = await getUserId();
    String address = "${_baseURL}contact";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'contact_userid': contactid.toString(),
      },
    );

    bool success = response.body == "true";
    return success;
  }

  Future<bool> acceptContact(contactid) async {
    String address = "${_baseURL}accept_contact_request";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'contact_id': contactid.toString(),
      },
    );

    return response.body == "true";
  }

  Future<bool> declineContact(contactid) async {
    String address = "${_baseURL}decline_contact_request";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'contact_id': contactid.toString(),
      },
    );

    return response.body == "true";
  }

  Future<bool> contactExists (int userid, int contact_userid) async{

    String address = "${_baseURL}contacts";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
      },
    );

    var $data = jsonDecode(response.body);

    for (var contact in $data){
      if(contact["receiver"] == contact_userid){
        return true;
      }
    }

    return false;
  }

  Future<dynamic> getMessages(int offset) async {
    int userid = await getUserId();
    String address = "${_baseURL}messages";

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'offset': offset.toString(),
      },
    );
    var $data = [];
    if(response.body.isNotEmpty) {
      $data = jsonDecode(response.body);
    }
    return $data;


  }
}