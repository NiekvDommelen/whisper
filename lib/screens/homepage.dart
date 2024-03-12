import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class userData {
  String username;
  String email;
  int userid;
  userData(this.username, this.email, this.userid);
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late Animation<double> drawerAnimation;
  late Animation<double> searchAnimation;
  late AnimationController drawerController;
  late AnimationController searchController;
  late FocusNode searchFocusNode = FocusNode();

  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  // TODO: add user information and text fields
  bool _isOpen = false;

  final _userData = userData("", "", 0);

  void getUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userid = prefs.getInt("userid");
    String address = 'http://10.59.138.102:3000/api/user';
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': userid.toString(),
      },
    );
    var $data = jsonDecode(response.body);
    debugPrint($data.toString());
    setState(() {
      _userData.username = $data["username"];
      _userData.email = $data["email"];
      _userData.userid = $data["id"];
      _usernameTextController.text = _userData.username;
      _emailTextController.text = _userData.email;
    });
  }

  void _logoutUser() async {
    setState(() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.popAndPushNamed(context, '/login');
    });
  }

  void _drawerClick(){
    setState(() {
      _isOpen = !_isOpen;
      if(_isOpen){
        drawerController.forward();
      }else{
        drawerController.reverse();
      }
    });

    debugPrint(_isOpen.toString());
  }
   List searchList = [];
   bool searchIsLoading = false;
   void _searchUsers($query) async{
    setState(() {
      searchIsLoading = true;
    });
    String address = 'http://192.168.1.78:3000/api/users';
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'query': $query,
      },
    );
    var $data = jsonDecode(response.body);
    debugPrint($data.toString());
    setState(() {
      searchList.clear();
      searchList = $data;
      searchIsLoading = false;
    });

  }

  List contactList = [];
  List invitationsList = [];
  List awaitingList = [];

  void _getContacts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final $userid = prefs.getInt("userid");
    String address = "http://10.59.138.101:3000/api/contacts";
    var response = await http.post(Uri.parse(address),

      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'userid': $userid.toString(),
      },
    );
    var $data = jsonDecode(response.body);
    setState(() {
      awaitingList.clear();
      invitationsList.clear();
      contactList.clear();
      for(var i = 0; i < $data.length; i++){
        if($data[i]["status"] == "awaiting" && $data[i]["sender"] == $userid){
          awaitingList.add($data[i]);
        }else if($data[i]["status"] == "accepted"){
          contactList.add($data[i]);
        }else if($data[i]["status"] == "awaiting" && $data[i]["receiver"] == $userid){
          invitationsList.add($data[i]);
        }
      }


    });
  }

  Widget drawer(double screenWidth){
    if(_isOpen){
      return FractionallySizedBox(
        widthFactor: 0.9,
        child: SizedBox(
          height: drawerAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary, borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15.0) ,bottomRight: Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 500,
                      ),
                      width: screenWidth - 125,
                      child: TextField(
                        controller: _usernameTextController,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: GoogleFonts.jura(
                              textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        style: GoogleFonts.jura(
                            textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _emailTextController,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: GoogleFonts.jura(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ),
                TextField(
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: GoogleFonts.jura(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ),
                Container(
                  height: 35,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,

                    border: Border.all(

                      color: Colors.lightGreenAccent,

                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: TextButton(
                      onPressed: null , child: Text("Save", style: TextStyle(color: Colors.white),)),
                ),
                const Expanded(child: SizedBox(),),
                IconButton(onPressed: _drawerClick, icon: const Icon(Icons.keyboard_arrow_up), visualDensity: VisualDensity(vertical: 0, horizontal: 4),),
              ],

            ),
          ),
        ),
      );
    }else{
      return FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          height: drawerAnimation.value,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary, borderRadius: BorderRadius.only(bottomLeft:Radius.circular(15.0) ,bottomRight: Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: _drawerClick, icon: const Icon(Icons.keyboard_arrow_down),visualDensity: VisualDensity(vertical: 0, horizontal: 4)),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();

    drawerController =
        AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    drawerAnimation = Tween<double>(begin: 40, end: 280).animate(drawerController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
    searchController =
        AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    searchAnimation = Tween<double>(begin: 0, end: 250).animate(searchController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });

  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenWidth - 60,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: TextField(
                      focusNode: searchFocusNode,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: GoogleFonts.jura(
                            textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      style: GoogleFonts.jura(
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      onTapOutside: (_pointerDownEvent){
                        setState(() {
                          searchFocusNode.unfocus();
                          searchController.reverse();
                        });

                      },
                      onChanged: (value) {
                        setState(() {
                          _searchUsers(value);
                        });
                      },
                      onTap: () {


                        setState(() {
                          searchFocusNode.requestFocus();
                          searchController.forward();
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          searchController.reverse();
                        });
                      },
                    ),
                  ),
                ),

                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        child: Text("Settings"),
                      ),
                      PopupMenuItem(
                        child: TextButton(onPressed: _logoutUser,child: Text("Logout", style: TextStyle(color: Colors.white),)),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: searchAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                height: searchAnimation.value,
                child: searchIsLoading
                    ? Center(
                  // Display a loading indicator while data is being fetched
                  child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary,),
              )
                  : ListView.builder(
                  // TODO: Limit will be set by api/database so item count can always be searchList length
                  itemCount: (searchList.length > 10) ? 10 : searchList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: ListTile(

                        //TODO: Change icon if user is already a friend/contact
                        //TODO: create a function to add user to contacts
                        trailing: IconButton( onPressed: null, icon: const Icon(Icons.person_add),),
                          titleTextStyle: GoogleFonts.jura(
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20,
                            ),
                          ),
                          title: Text(searchList[index]["username"]),
                        ),
                    );
                  },
                ),
              );
            },
          ),

          drawer(screenWidth),
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
