import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/userdata.dart';
import "package:pointycastle/export.dart";
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:basic_utils/basic_utils.dart';

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

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    // Create an RSA key generator and initialize it

    // final keyGen = KeyGenerator('RSA'); // Get using registry
    final keyGen = RSAKeyGenerator();

    keyGen.init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom exampleSecureRandom() {

    final secureRandom = SecureRandom('Fortuna')
      ..seed(KeyParameter(
          Platform.instance.platformEntropySource().getBytes(32)));
    return secureRandom;
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userid = prefs.getInt("userid") ?? 0;
    return userid;
  }

  Future<dynamic> searchUserData(userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = "${_baseURL}user";

    var token = prefs.getString("token");
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'token': token
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = await getUserId();
    String address = "${_baseURL}user";
    var token = prefs.getString("token");
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'token': token
      },
    );

    if(response.body.isNotEmpty) {
      var $data = jsonDecode(response.body);
      return $data;
    }else{
      return null;
    }

  }

  Future<bool> checkLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = "${_baseURL}login";
    var username = prefs.getString('username');
    var password = prefs.getString('password');
    var publicPem = prefs.getString('publicPem');

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'username': username,
        'password': password,
        'publicKey': publicPem.toString()
      },
    );

    var $data = jsonDecode(response.body);
    if($data["success"] == true){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> loginUser(String username, String password) async{
    String address = "${_baseURL}login";

    final pair = generateRSAkeyPair(exampleSecureRandom());
    final public = pair.publicKey;
    final private = pair.privateKey;
    final privatePem = CryptoUtils.encodeRSAPrivateKeyToPem(private);
    final publicPem = CryptoUtils.encodeRSAPublicKeyToPem(public);

    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'username': username,
        'password': password,
        'publicKey': publicPem.toString()
      },
    );
    var $data = jsonDecode(response.body);
    if($data["success"] == true){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', true);
        prefs.setInt('userid', $data["userid"]);
        prefs.setString('username', username);
        prefs.setString('password', password);
        prefs.setString('token', $data['token']);
        prefs.setString('privatePem', privatePem);
        prefs.setString('publicPem', publicPem);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = await getUserId();
    String address = "${_baseURL}users";
    var token = prefs.getString('token');
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'query': search,
        'token': token,
        'userid': userid.toString()
      },
    );

    if(response.body.isNotEmpty) {
      var $data = jsonDecode(response.body);
      return $data;
    }
    return {};
  }

  Future<dynamic> getContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = await getUserId();
    String address = "${_baseURL}contacts";
    var token = prefs.getString('token');
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'token': token,
        'userid': userid.toString(),
      },
    );
    if(response.body.isNotEmpty) {
      var $data = jsonDecode(response.body);
      return $data;
    }
    return [];
  }

  Future<bool> addContact(contactid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = await getUserId();
    String address = "${_baseURL}contact";
    var token = prefs.getString('token');
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'contact_userid': contactid.toString(),
        'token': token
      },
    );

    bool success = response.body == "true";
    return success;
  }

  Future<bool> acceptContact(contactid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = "${_baseURL}accept_contact_request";
    var token = prefs.getString('token');
    var userid = await getUserId();
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'contact_id': contactid.toString(),
        'token': token
      },
    );

    return response.body == "true";
  }

  Future<bool> declineContact(contactid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = "${_baseURL}decline_contact_request";

    var token = prefs.getString('token');
    var userid = await getUserId();
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'contact_id': contactid.toString(),
        'token': token
      },
    );

    return response.body == "true";
  }

  Future<bool> contactExists (int userid, int contact_userid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = "${_baseURL}contacts";
    var token = prefs.getString('token');
    var userid = await getUserId();
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'token': token
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = await getUserId();
    String address = "${_baseURL}messages";

    var token = prefs.getString('token');
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
        'offset': offset.toString(),
        'token': token
      },
    );
    var $data = [];
    if(response.body.isNotEmpty) {
      $data = jsonDecode(response.body);
    }
    return $data;


  }
}