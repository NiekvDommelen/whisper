import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),

      routes:{
        '/': (context) => const HomePage(),
        '/chat': (context) => const ChatPage(),
      }

    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  @override
  Widget build(BuildContext context) {


  }

}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});




  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {

  List<Widget> elementList = [];
  
  List<dynamic> msgIdList = [];

  final TextEditingController _controller = TextEditingController();

  FocusNode msgInputFocusNode = FocusNode();


  static get ipAddress => "10.59.138.115";
  static get portNumber => 3000;

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://$ipAddress:$portNumber'),
  );

  final ScrollController _scrollController = ScrollController();


  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.extentTotal,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }


  Widget _recieveChatMsg(String msg) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[Container(
          constraints: const BoxConstraints(minWidth: 20, maxWidth: double.infinity),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(msg, style: const TextStyle(color: Colors.white)),
        )],
      ),
    );
  }

  Widget _addChatMsg(String msg) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children:[Container(
          constraints: BoxConstraints(minWidth: 20, maxWidth: double.infinity),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(msg, style: const TextStyle(color: Colors.white)),
        )],
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Chat App", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Center(

        child: Column(

          children: [

            SizedBox(
              key: const ValueKey("chat_input"),
              width: screenWidth,
              height: screenHeight - 116,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[Container(
                        constraints: BoxConstraints(minWidth: 100, maxWidth: screenWidth * 0.8),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("Filler Filler Filler Filler Filler Filler Filler Filler Filler Filler Filler ", style: TextStyle(color: Colors.white)),
                      ),
                        StreamBuilder(
                          stream: channel.stream,
                          builder: (context, snapshot) {

                            if (snapshot.hasData) {
                              final data = jsonDecode(snapshot.data.toString()) as Map<String, dynamic>;
                              final msgId = data["id"]; // Replace this with your logic for generating a unique identifier
                              final receivedMsg = data["msg"];
                              // Check if a message with the same identifier is not already in the list
                              if (!msgIdList.any((element) => element == msgId)) {
                                msgIdList.add(msgId);
                                elementList.add(_recieveChatMsg(receivedMsg));

                                Future.microtask(() {
                                  if (mounted) {
                                    setState(() {_scrollDown();}); // Notify Flutter to rebuild the widget tree
                                  }
                                });

                              }
                            }
                            return SizedBox.shrink();

                          },
                        ),
                      ],

                    ),
                    Expanded(

                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: elementList.length,
                        itemBuilder: (context, index) {
                          return elementList[index];
                        },
                      ),
                    ),



                    
                  ],
                ),
              )
            ),

            Column(

              children: [
                Container(
                  height: 60,

                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,


                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: screenWidth * 0.8,
                          height: 50,
                          child: Container(
                            margin: const EdgeInsets.all(2),

                            child: TextField(


                              minLines: 1,
                              maxLines: 1,
                              obscureText: false,
                              focusNode: msgInputFocusNode,
                              controller: _controller,
                              onSubmitted: (String value) {
                                setState(() {
                                  if(value.trim().isEmpty) return;
                                  elementList.add(_addChatMsg(value));
                                  _controller.clear();
                                  msgInputFocusNode.requestFocus();
                                  _scrollDown();
                                  channel.sink.add(value);



                                });
                              },
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white12,

                              decoration: const InputDecoration(
                                isDense: true,


                                focusColor: Colors.white,
                                hoverColor: Colors.white,

                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),

                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),

                                hintText: 'Message',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if(_controller.text.trim().isEmpty) return;
                            elementList.add(_addChatMsg(_controller.text));
                            channel.sink.add(_controller.text);
                            _controller.clear();
                            msgInputFocusNode.requestFocus();
                            _scrollDown();

                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )

      ),

    );
  }
}
