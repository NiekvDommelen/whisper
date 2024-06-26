import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:basic_utils/basic_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart" as pc;
import 'dart:typed_data';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<ChatPage> createState() => _ChatPage(data);
}

class _ChatPage extends State<ChatPage> {
  late StreamSubscription streamSubscription;

  TextEditingController chatInputController = TextEditingController();



  List<dynamic> messages = [];
  bool loading = true;
  late int userid;

  _ChatPage(this.data);
  final Map<String, dynamic> data;

  Future<bool> setup() async {
    await getMessages(0);
    return true;
  }

  Future<bool> getMessages(offset) async {
    var tmpuserid = await Api.getUserId();
    Api.getMessages(offset).then((value) => {
          setState(() {

            value.forEach((el) async {
              debugPrint("BEGIN EL:");
              debugPrint(el.toString());
              if (el["sender"].toString() == tmpuserid.toString() && el["receiver"].toString() == data["contact_user"].toString()){

                var decrypted;
                try {
                  decrypted = await decrypte(el["sender_message_data"]);
                } on Exception catch (exception) {
                  decrypted = "Message could not be decrypted";
                } catch (error) {
                  decrypted = "Something went wrong while decrypting";
                }
                el["message_data"] = decrypted;
                debugPrint("end EL:");
                debugPrint(el.toString());
                messages.add(el);

              } else if(el["sender"].toString() == // if received
                  data["contact_user"].toString() &&
                  el["receiver"].toString() ==
                      tmpuserid.toString()){
                var decrypted;
                try {
                  decrypted = await decrypte(el["message_data"]);
                } on Exception catch (exception) {
                  decrypted = "Message could not be decrypted";
                } catch (error) {
                  decrypted = "Something went wrong while decrypting";
                }

                el["message_data"] = decrypted;
                debugPrint("end EL:");
                debugPrint(el.toString());
                messages.add(el);
              }


            });
            debugPrint(value.toString());

            userid = tmpuserid;
          })
        });
    return true;
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = pc.OAEPEncoding(pc.RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = pc.OAEPEncoding(pc.RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final contact_publicPem = await Api.getPublicKey(data["contact_user"].toString());
    final publicPem = prefs.getString("publicPem");
    if(publicPem == null){
      // session expired
      //TODO: LOG OUT USER
      return;
    }

    final publicRSA = CryptoUtils.rsaPublicKeyFromPem(publicPem);
    final contact_publicRSA = CryptoUtils.rsaPublicKeyFromPem(contact_publicPem);

    debugPrint("publicRSA");
    debugPrint(publicRSA.toString());

    var chatdata = chatInputController.value.text;

    if (chatdata.trim() == "") {
      return;
    }
    final bytes = utf8.encode(chatdata);
    var encrypted = rsaEncrypt(publicRSA, bytes);
    var contact_encrypted = rsaEncrypt(contact_publicRSA, bytes);

    var token = prefs.getString("token");

    ws.channel.sink.add(jsonEncode({
      "receiver": data["contact_user"],
      "message_data": contact_encrypted,
      "sender_message_data": encrypted,
      "token": token
    }));
    chatInputController.clear();
  }

  decrypte(encrypte) async {
    debugPrint(encrypte.toString());
    var base64 = base64Decode(encrypte);
    debugPrint(base64.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final privatePem = prefs.getString("privatePem");
    final publicPem = prefs.getString("publicPem");

    if(privatePem == null){
      // session expired
      //TODO: LOG OUT USER
      return;
    }
    final privateRSA = CryptoUtils.rsaPrivateKeyFromPem(privatePem);
    final publicRSA = CryptoUtils.rsaPublicKeyFromPem(publicPem!);
    debugPrint(" privateRSA and publicRSA");
    debugPrint(privateRSA.toString());
    debugPrint(publicRSA.toString());
    var decrypte = rsaDecrypt(privateRSA, base64);
    var text = utf8.decode(decrypte).toString();
    debugPrint(text);
    return text;
  }

  @override
  void initState() {
    super.initState();
    setup().then((value) => {
          setState(() {


            streamSubscription = chatStream.stream.listen((event) async {
              debugPrint("BEGIN EVENT:");
              debugPrint(event.toString());

              if (event["sender"].toString() == userid.toString() && event["receiver"].toString() == data["contact_user"].toString()){
                try {
                  event["message_data"] = await decrypte(event["sender_message_data"]);
                } on Exception catch (exception) {
                  event["message_data"] = "Message could not be decrypted";
                } catch (error) {
                  event["message_data"] = "Something went wrong while decrypting";
                }
              }else{
                try {
                  event["message_data"] = await decrypte(event["message_data"]);
                } on Exception catch (exception) {
                  event["message_data"] = "Message could not be decrypted";
                } catch (error) {
                  event["message_data"] = "Something went wrong while decrypting";
                }
              }

              debugPrint("end EVENT:");
              debugPrint(event.toString());
              setState(() {
                messages.insert(0, event);
              });


            });
            loading = false;
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
      body: Column(children: [
        Expanded(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var time =
                        DateTime.parse(messages[index]["timestamp"]);
                    var displayHour = time.hour.toString();
                    var displayMinute = time.minute.toString();

                    if (displayHour.length == 1) {
                      displayHour = "0${time.hour}";
                    }
                    if (displayMinute.length == 1) {
                      displayMinute = "0${time.minute}";
                    }

                    var displayTime = "$displayHour:$displayMinute";

                    if (messages[index]["sender"].toString() == userid.toString() && messages[index]["receiver"].toString() == data["contact_user"].toString()) { // if send

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              width: screenWidth - 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    displayTime,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                    child: Text(messages[index]["message_data"],
                                        style: const TextStyle(fontSize: 12)),
                                  ),
                                ],
                              )),
                        ],
                      );
                    } else if (messages[index]["sender"].toString() == // if received
                            data["contact_user"].toString() &&
                        messages[index]["receiver"].toString() ==
                            userid.toString()) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              width: screenWidth - 30,
                              child: Row(
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
                                    child: Text(messages[index]["message_data"],
                                        style: const TextStyle(fontSize: 12)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    displayTime,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              )),
                        ],
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
                  onPressed: () {
                    sendMessage();
                  }),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}
