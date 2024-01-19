import 'package:flutter/material.dart';


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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> elementList = [];

  final TextEditingController _controller = TextEditingController();

  FocusNode msgInputFocusNode = FocusNode();

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
          constraints: BoxConstraints(minWidth: 100, maxWidth: double.infinity),
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

        title: Text(widget.title),
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
                      )],
                    ),
                    Expanded(

                      child: ListView.builder(
                      controller: _scrollController,

                      itemCount: elementList.length,
                      itemBuilder: (context, index) {
                        if (index < elementList.length) {
                          return elementList[index];
                        } else {
                          return const SizedBox();
                        }
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
                            _controller.clear();
                            msgInputFocusNode.requestFocus();
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
