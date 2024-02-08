import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: 'Whisper',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              primary: const Color.fromARGB(255, 81, 43, 129),
              onPrimary: const Color.fromARGB(255, 68, 119, 206),
              secondary: const Color.fromARGB(255, 53, 21, 93),
              onSecondary: const Color.fromARGB(40, 84, 35, 146),
              surface: const Color.fromARGB(255, 53, 21, 93),
              brightness: Brightness.dark,
              seedColor: const Color.fromARGB(255, 53, 21, 93)),
        ),
        routes: {
          '/': (context) => const LoginPage(), // Homepage()
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Whisper",
            style: GoogleFonts.jura(
                textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w800))),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  width: screenWidth - 20,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text("N",
                            style: GoogleFonts.jura(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth - 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Niek",
                                    style: GoogleFonts.jura(
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800))),
                                Text(
                                  "chat message go brrrrrrrbr",
                                  style: GoogleFonts.jura(
                                      textStyle:
                                          TextStyle(color: Colors.white70),
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 35,
                            alignment: Alignment.topCenter,
                            child: Text("9:49",
                                style: GoogleFonts.jura(
                                    textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800))),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  width: screenWidth - 20,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text("N",
                            style: GoogleFonts.jura(
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth - 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Niek",
                                    style: GoogleFonts.jura(
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800))),
                                Text(
                                  "chat message go brrrrrrrrrrrr",
                                  style: GoogleFonts.jura(
                                      textStyle:
                                          TextStyle(color: Colors.white70),
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 35,
                            alignment: Alignment.topCenter,
                            child: Text("9:49",
                                style: GoogleFonts.jura(
                                    textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800))),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  FocusNode _usernameTextFieldFocusNode = FocusNode();
  bool _isUsernameFocused = false;

  FocusNode _passwordTextFieldFocusNode = FocusNode();
  bool _isPasswordFocused = false;

  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Login to whisper",
          style: GoogleFonts.jura(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: Center(
        heightFactor: 0.6,
        child: SizedBox(
          width: screenWidth - 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "login",
                style: GoogleFonts.jura(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isUsernameFocused = hasFocus;
                  });
                },
                child: AnimatedOpacity(
                  opacity: _isUsernameFocused ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _isUsernameFocused ? Theme.of(context).colorScheme.onPrimary : Color.fromARGB(125, 112, 0, 255),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: _usernameTextController,
                      focusNode: _usernameTextFieldFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isPasswordFocused = hasFocus;
                  });
                },
                child: AnimatedOpacity(
                  opacity: _isPasswordFocused ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _isPasswordFocused ? Theme.of(context).colorScheme.onPrimary : Color.fromARGB(125, 112, 0, 255),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: TextField(
                      obscureText: true,
                      autocorrect: false,
                      controller: _passwordTextController,
                      focusNode: _passwordTextFieldFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              _usernameTextController.text != "" && _passwordTextController.text != ""
                ? Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,

                    border: Border.all(

                      color: Colors.lightGreenAccent,

                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                    child: TextButton(
                        style: ButtonStyle(

                        ),
                        onPressed: null , child: Text("Continue", style: TextStyle(color: Colors.white),)),
                  )
              : Container(
              decoration: BoxDecoration(
              color: Colors.transparent,

              border: Border.all(

              color: Colors.green,

              ),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: TextButton(
                style: ButtonStyle(

                ),
                onPressed: null , child: Text("Continue")),
          ),
            SizedBox(height: 20),
              Text("Dont have an account?", style: TextStyle(color: Colors.grey)),
              TextButton(onPressed: null, child: Text("sign-up", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, decoration: TextDecoration.underline, decorationColor: Theme.of(context).colorScheme.onPrimary),))
            ],
          ),
        ),
      )
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  // create list to store the widgets from chat messages
  List<Widget> elementList = [];
  // create list to store received message id's
  List<dynamic> msgIdList = [];
  // create TextEditingController variable for the text field
  final TextEditingController _controller = TextEditingController();
  // create FocusNode variable for the text field
  FocusNode msgInputFocusNode = FocusNode();
  // create variables for the server ip address and port number
  static get ipAddress => "10.59.138.103";
  static get portNumber => 3000;
  // create WebSocketChannel variable and set it to null
  var channel;

  void _startChat() {
    // Connect to the server
    channel = WebSocketChannel.connect(
      Uri.parse('ws://$ipAddress:$portNumber'),
    );
    setState(() {
      // Add a system message to the list
      elementList.add(_addSystemMsg("Connected to server"));
    });
  }

  void _closeChat() {
    if (channel != null) {
      // close connection with the server
      channel.sink.close();
    }
    setState(() {
      // clear id list and set channel(connection status) to null
      channel = null;
      msgIdList.clear();
    });
  }
  // create ScrollController
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    // scroll to the bottom of the list
    _scrollController.animateTo(
      // get the total height of the list
      _scrollController.position.extentTotal,
      // set the duration of the animation
      duration: const Duration(seconds: 1),
      // set the curve of the animation
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget _addMenu() {
    // return FractionallySizedBox with the menu
    return FractionallySizedBox(
      widthFactor: 1,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              constraints:
                  const BoxConstraints(minWidth: 20, maxWidth: double.infinity),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(7),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Welcome to Whisper!!",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        elementList.clear();
                        _startChat();
                      },
                      child: const Text("Start Chat",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ]))
        ],
      ),
    );
  }

  Widget _recieveChatMsg(String msg) {
    // return FractionallySizedBox with the received chat message
    return FractionallySizedBox(
      widthFactor: 0.8,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints:
                const BoxConstraints(minWidth: 20, maxWidth: double.infinity),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(msg, style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _addChatMsg(String msg) {
    // return FractionallySizedBox with the chat message
    return FractionallySizedBox(
      widthFactor: 0.8,
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints:
                BoxConstraints(minWidth: 20, maxWidth: double.infinity),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(msg, style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _addSystemMsg(String msg) {
    // return FractionallySizedBox with the system message
    return FractionallySizedBox(
      widthFactor: 0.9,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints:
                BoxConstraints(minWidth: 20, maxWidth: double.infinity),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(7),
            child: Text(msg, style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // add menu to the list on start
    elementList.add(_addMenu());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Whisper",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
              key: const ValueKey("chat_input"),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Check if the connection is open
                        if (channel != null)
                          StreamBuilder(
                            stream: channel.stream,
                            builder: (context, snapshot) {
                              // Check if the snapshot has data
                              if (snapshot.hasData) {
                                // Decode the json data
                                final data =
                                    jsonDecode(snapshot.data.toString())
                                        as Map<String, dynamic>;
                                final msgId = data["id"]; // Message id
                                final receivedMsg =
                                    data["msg"]; // Message data (text)
                                // Check if a message with the same identifier is not already in the list
                                if (!msgIdList
                                    .any((element) => element == msgId)) {
                                  // Add the message id to the list
                                  msgIdList.add(msgId);
                                  // Check if the message is a system message
                                  if (msgId.toString().contains("system_msg")) {
                                    // Add the system message to the list
                                    elementList.add(_addSystemMsg(receivedMsg));
                                    // Check if the message is a disconnect message
                                    if (msgId
                                        .toString()
                                        .contains("system_msg_4")) {
                                      // close connection with the server
                                      channel = null;
                                      // clear the list of received message id's
                                      msgIdList.clear();
                                      // add menu to the list
                                      elementList.add(_addMenu());
                                    }
                                  } else {
                                    // Add the message to the list
                                    elementList
                                        .add(_recieveChatMsg(receivedMsg));
                                  }

                                  Future.microtask(() {
                                    // Check if the widget is mounted
                                    if (mounted) {
                                      setState(() {
                                        // scroll to the bottom of the list
                                        _scrollDown();
                                      }); // Notify Flutter to rebuild the widget tree
                                    }
                                  });
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: elementList.length,
                        itemBuilder: (context, index) {
                          // Return the widget's from the list
                          return elementList[index];
                        },
                      ),
                    ),
                  ],
                ),
              )),
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
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          // close connection with the server
                          _closeChat();
                          // clear id list and set channel(connection status) to null
                          channel = null;
                          // clear the list of received message id's
                          msgIdList.clear();
                          // add menu to the list
                          elementList.add(_addMenu());
                          // scroll to the bottom of the list
                          _scrollDown();
                        });
                      },
                    ),
                    SizedBox(
                        width: screenWidth * 0.7,
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
                                // Check if the message is empty
                                if (value.trim().isEmpty) return;
                                // Add the message to the list
                                elementList.add(_addChatMsg(value));
                                // empty the controller and text field
                                _controller.clear();
                                // set focus to the text field
                                msgInputFocusNode.requestFocus();
                                // scroll to the bottom of the list
                                _scrollDown();
                                // Send the message to the server
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
                        )),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          // Check if the message is empty
                          if (_controller.text.trim().isEmpty) return;
                          // Add the message to the list
                          elementList.add(_addChatMsg(_controller.text));
                          // Send the message to the server
                          channel.sink.add(_controller.text);
                          // empty the controller and text field
                          _controller.clear();
                          // set focus to the text field
                          msgInputFocusNode.requestFocus();
                          // scroll to the bottom of the list
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
      )),
    );
  }
}
