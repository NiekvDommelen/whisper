import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api.dart';
import 'main.dart';
import 'userdata.dart';

late api Api;

void setupAndRunApp({required api service}) {
  Api = service;
  runApp(const MyApp());
}

userdata Userdata = userdata(0, "", "");
Ws ws = Ws();

var chatStream = StreamController.broadcast();

class Ws {
  late WebSocketChannel _channel;
  WebSocketChannel get channel => _channel;



  void connect(int userid) async{
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.59.138.132:3001'),
    );
    await _channel.ready;

    _channel.sink.add(jsonEncode({"userid": userid, "status": "connecting"}));

  }

}





void setup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool('loggedIn') ?? false ){
    var userid = prefs.getInt('userid') ?? 0;
    var userdata = await Api.searchUserData(userid);
    Userdata.username = userdata["username"];
    Userdata.email = userdata["email"];
    Userdata.userid = userdata["id"];
    ws.connect(Userdata.userid);
    ws.channel.stream.listen((data) {
      chatStream.add(jsonDecode(data));
    });

  }
}