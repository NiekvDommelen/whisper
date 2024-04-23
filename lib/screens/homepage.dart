
import '../setup.dart';
import 'chatpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late Animation<double> drawerAnimation;
  late Animation<double> searchAnimation;
  late AnimationController drawerController;
  late AnimationController searchController;
  late FocusNode searchFocusNode = FocusNode();

  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _searchTextController = TextEditingController();


  bool _isOpen = false;

  //api.dart
  void getUserData() async{
    var data = await Api.getUserData();
    setState(() {
      _usernameTextController.text = data["username"];
      _emailTextController.text = data["email"];
    });
  }
  //api.dart
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
  var searchList = [];
  bool searchIsLoading = false;
  Future<bool> _searchUsers($query) async{
    setState(() {
      searchIsLoading = true;
    });
    var $data = await Api.searchUsers($query);
    searchList.clear();
    searchList = $data;

    for (int i = 0; i < searchList.length; i++) {
      await Api.contactExists(Userdata.userid, searchList[i]["id"]).then((value) {
        if(value){
          searchList[i]["contact"] = true;
        }else{
          searchList[i]["contact"] = false;
        }

      });
    }

    setState(() {
      searchIsLoading = false;
    });
    return true;
  }

  List contactList = [];
  List invitationsList = [];
  List awaitingList = [];

  void _getContacts() async{
    var $data = await Api.getContacts();
    setState(() {
      awaitingList.clear();
      invitationsList.clear();
      contactList.clear();
      debugPrint(Userdata.userid.toString());
      for(var i = 0; i < $data.length; i++){
        if($data[i]["status"] == "awaiting" && $data[i]["sender"] == Userdata.userid || $data[i]["status"] == "declined" && $data[i]["sender"] == Userdata.userid){
          awaitingList.add($data[i]);
        }else if($data[i]["status"] == "accepted"){
          contactList.add($data[i]);
        }else if($data[i]["status"] == "awaiting" && $data[i]["receiver"] == Userdata.userid){
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
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary, borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(15.0) ,bottomRight: Radius.circular(15.0))),
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
                      constraints: const BoxConstraints(
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
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  child: const TextButton(
                      onPressed: null , child: Text("Save", style: TextStyle(color: Colors.white),)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: _drawerClick, icon: const Icon(Icons.keyboard_arrow_up), visualDensity: const VisualDensity(vertical: 0, horizontal: 4),),
                  ],
                )

              ],

            ),
          ),
        ),
      );
    }else{
      return FractionallySizedBox(
        widthFactor: 0.9,
        child: SizedBox(
          height: drawerAnimation.value,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary, borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(15.0) ,bottomRight: Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: _drawerClick, icon: const Icon(Icons.keyboard_arrow_down),visualDensity: const VisualDensity(vertical: 0, horizontal: 4)),
              ],
            ),
          ),
        ),
      );
    }
  }
  // ______DEBUG______
  Widget debugBtn(){
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, "/debug");
      },
      child: const Icon(Icons.developer_mode, color: Colors.white,),
    );
  }
  // ______END DEBUG______
  @override
  void initState() {
    super.initState();
    setup();
    getUserData();
    _getContacts();

    drawerController =
        AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    drawerAnimation = Tween<double>(begin: 50, end: 300).animate(drawerController)
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // ______DEBUG______
      floatingActionButton: debugBtn(),
      // ______END DEBUG______
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 60,
              child: DrawerHeader(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Contacts',
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2.0,
                  ),
                ),
              ),
              child: Text("Invitations" , style: GoogleFonts.jura(
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800))
              ),
            ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: invitationsList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: ListTile(
                      title: Text(invitationsList[index]["sender"].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                var response = Api.acceptContact(invitationsList[index]["contact_id"]);
                                if(await response){
                                  _getContacts();
                                }else{
                                  const SnackBar(
                                    content: Text('Failed to accept invitation, please try again later.'),
                                    duration: Duration(seconds: 3),
                                  );
                                }

                              },
                              icon: const Icon(Icons.check, color: Colors.green,),
                            ),
                            IconButton(
                              onPressed: () async {
                                var response = Api.declineContact(invitationsList[index]["contact"]);
                                if(await response){
                                  _getContacts();
                                }else{
                                  const SnackBar(
                                    content: Text('Failed to decline invitation, please try again later.'),
                                    duration: Duration(seconds: 3),
                                  );
                                }

                              },
                              icon: const Icon(Icons.close, color: Colors.red,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: awaitingList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: ListTile(
                    title: Text(awaitingList[index]["receiver"].toString()),
                    trailing: const SizedBox(
                      width: 100,
                      child: Text("Awaiting", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                );
              },
            ),


            Container(
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2.0,
                  ),
                ),
              ),
              child: Text("Contacts" , style: GoogleFonts.jura(
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800))
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: ListTile(
                    title: (contactList[index]["sender"] == Userdata.username) ? Text(contactList[index]["receiver"].toString()) : Text(contactList[index]["sender"].toString()),
                    trailing: const SizedBox(
                      width: 100,
                      child: Text("accepted", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                );
              },
            ),
          ],
        ),

      ),
      body:
      Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {_getContacts(); _scaffoldKey.currentState!.openDrawer();},
                  icon: const Icon(Icons.contacts_outlined),
                ),
                SizedBox(
                  width: screenWidth - 120,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: TextField(
                      controller: _searchTextController,
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
                        if(_pointerDownEvent.position.dy > 300){
                          setState(() {
                            searchFocusNode.unfocus();
                            searchController.reverse();
                          });
                        }
                      },
                      onChanged: (value) async {
                        await _searchUsers(value);
                        setState(() {

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
                        child: TextButton(onPressed: _logoutUser,child: const Text("Logout", style: TextStyle(color: Colors.white),)),
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
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(25)),
                        ),
                        child: ListTile(


                          //TODO: if user is already a contact but invite is pending show a checkmark, if its accepted show a chat icon that redirect the user to the chat
                          trailing: !searchList[index]["contact"] ? IconButton(
                            onPressed: () async {
                              var response = await Api.addContact(searchList[index]["id"]);
                              if(response){
                                setState(() {
                                  _searchUsers(_searchTextController.text);
                                  _getContacts();
                                });
                              }else{
                                const SnackBar(
                                  content: Text('Failed to send invitation, please try again later.'),
                                  duration: Duration(seconds: 3),
                                );
                              }
                            },
                            icon: const Icon(Icons.person_add),
                          )
                           : const Icon(Icons.check),
                          titleTextStyle: GoogleFonts.jura(
                            textStyle: TextStyle(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onPrimary,
                              fontSize: 20,
                            ),
                          ),
                          title: Text(searchList[index]["username"]),
                        ),
                      );
                    }
                ),
              );
            },
          ),

          drawer(screenWidth),
          Container(
            height: screenHeight - 133,
            child:
          ListView(
            children: [
              Container(
                  height: screenHeight - 133,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child:
              ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: screenWidth - 20,
                      height: 80,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      child: TextButton(style: TextButton.styleFrom(
                        minimumSize: Size.zero, // Set this
                        padding: EdgeInsets.zero, // and this
                      ),
                          onPressed: () => {Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(data: {"contact_user": (contactList[index]["sender"] == Userdata.username) ? contactList[index]["receiver"].toString() : contactList[index]["sender"].toString(),}),

                        ),
                      )}, child: Row(
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
                            child: Text((contactList[index]["sender"] == Userdata.username) ? contactList[index]["receiver"].toString() : contactList[index]["sender"].toString(),
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
                              SizedBox(
                                width: screenWidth - 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text((contactList[index]["sender"] == Userdata.username) ? contactList[index]["receiver"].toString() : contactList[index]["sender"].toString(),
                                        style: GoogleFonts.jura(
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800))),
                                    Text(
                                      "for later",
                                      style: GoogleFonts.jura(
                                          textStyle:
                                          const TextStyle(color: Colors.white70),
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 35,
                                alignment: Alignment.topCenter,
                                child: Text("22:22",
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
                      )),);
                  }
              )
              )
            ],
          ),
          ),
        ],
      ),
    );
  }
}
