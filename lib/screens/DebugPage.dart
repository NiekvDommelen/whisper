import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "../setup.dart";

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPage();
}

class _DebugPage extends State<DebugPage> {

  var apiData = {};
  void dataWidget() async {
    apiData = await Api.debugApiData();
    debugPrint(apiData.toString());
    debugPrint(apiData["Userid"].toString());
    setState(() {
    });
  }


  @override
  void initState() {
    super.initState();
    setup();
    dataWidget();


  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: Center(
        child:Column(
          children: [
            Text("Userdata", style: TextStyle(fontSize: 20)),
            Text("userid: ${Userdata.userid}"),
            Text("username: ${Userdata.username}"),
            Text("email: ${Userdata.email}"),
            Text("API", style: TextStyle(fontSize: 20)),
            Text("baseURL: ${apiData["_baseURL"].toString()}"),
            Text("Userid: ${apiData["Userid"].toString()}"),
            Text("Username: ${apiData["Username"].toString()}"),
            Text("Email: ${apiData["Email"].toString()}"),
          ],
        ),
      ),
    );
  }
}