import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<ChatPage> createState() => _ChatPage(data);
}

class _ChatPage extends State<ChatPage>{

  late StreamSubscription streamSubscription;

  TextEditingController chatInputController = TextEditingController();

  List<dynamic> messages = [];
  bool loading = true;
  late int userid;


  _ChatPage(this.data);
  final Map<String, dynamic> data;

  Future<bool> setup() async{
    await getMessages(0);
    return true;
  }

  Future<bool> getMessages(offset) async{
    var tmpuserid = await Api.getUserId();
    Api.getMessages(offset).then((value) => {
        setState(() {
        messages = value;
        userid = tmpuserid;
      })

    });
    return true;
  }





  @override
  void initState()  {
    super.initState();
    setup().then((value) => {
      setState(() {
        loading = false;

        streamSubscription = chatStream.stream.listen((event) {
          setState(() {
            messages.insert(0, event);
          });
        });
      })
    });


  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '${data["contact_user"]}',
          style: GoogleFonts.jura(
              textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(

        children: [

          Expanded(
            child: loading ? const Center(
                  child: CircularProgressIndicator(),
                ) : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index){
                    var time = DateTime.parse(messages[index]["timestamp"].toString());
                    var displayHour = time.hour.toString();
                    var displayMinute = time.minute.toString();

                    if(displayHour.length == 1){
                      displayHour = "0${time.hour}";
                    }
                    if(displayMinute.length == 1){
                      displayMinute = "0${time.minute}";
                    }

                    var displayTime = "$displayHour:$displayMinute";


                    if(messages[index]["sender"].toString() == userid.toString() && messages[index]["receiver"].toString() == data["contact_user"].toString()){


                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Container(
                            margin: EdgeInsets.only(right: 10),
                            width: screenWidth - 30,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(displayTime, style: const TextStyle(fontSize: 12, color: Colors.grey),),

                                SizedBox(width: 10,),

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(30, 100, 100, 100),
                                  ),
                                  constraints: BoxConstraints(
                                    // minWidth: 0,
                                    maxWidth: screenWidth - screenWidth / 3,
                                  ),

                                  child: Text(messages[index]["message_data"], style: const TextStyle(fontSize: 12)),
                                ),





                              ],
                            )

                        ),],
                      );
                    }else if(messages[index]["sender"].toString() == data["contact_user"].toString() && messages[index]["receiver"].toString() == userid.toString()) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Container(
                            margin: EdgeInsets.only(left: 10),
                            width: screenWidth - 30,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(150, 100, 100, 100),
                                  ),
                                  constraints: BoxConstraints(
                                    // minWidth: 0,
                                    maxWidth: screenWidth - screenWidth / 3,
                                  ),

                                  child: Text(messages[index]["message_data"], style: const TextStyle(fontSize: 12)),
                                ),

                                SizedBox(width: 10,),

                                Text(displayTime, style: const TextStyle(fontSize: 12, color: Colors.grey),),

                              ],
                            )

                        ),],
                      );
                    }
                  },
                ),


            ),
          // StreamBuilder(
          //   stream: stream,
          //   builder: (context, snapshot) {
          //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
          //   },
          // ),


          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatInputController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: (){ if(chatInputController.value.text.trim() == ""){return;} ws.channel.sink.add(jsonEncode({"receiver": data["contact_user"], "message_data": chatInputController.value.text})); chatInputController.clear();}
                ),
              ],
            ),
          ),
    ]
    ),
    );
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}