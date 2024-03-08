import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  FocusNode _usernameTextFieldFocusNode = FocusNode();
  bool _isUsernameFocused = false;

  FocusNode _emailTextFieldFocusNode = FocusNode();
  bool _isEmailFocused = false;

  FocusNode _passwordTextFieldFocusNode = FocusNode();
  bool _isPasswordFocused = false;

  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  void _SignupUser() async {
    String username = _usernameTextController.text;
    String password = _passwordTextController.text;
    String email = _emailTextController.text;
    String address = 'http://192.168.1.79:3000/api/signup';
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

    debugPrint(response.body);
    var $data = jsonDecode(response.body);
    if($data["success"] = true){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true);
      prefs.setBool('userid', $data["userid"]);
      Navigator.popAndPushNamed(context, '/home');
    }else{
      debugPrint('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          heightFactor: 0.8,
          child: SizedBox(
            width: screenWidth - 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign-up",
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
                      _isEmailFocused = hasFocus;
                    });
                  },
                  child: AnimatedOpacity(
                    opacity: _isEmailFocused ? 1.0 : 0.5,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isEmailFocused ? Theme.of(context).colorScheme.onPrimary : Color.fromARGB(125, 112, 0, 255),
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _emailTextController,
                        focusNode: _emailTextFieldFocusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
                          hintText: 'Enter your Email',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
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
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
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
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
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
                      onPressed: _SignupUser , child: Text("Continue", style: TextStyle(color: Colors.white),)),
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
                Text("Already have an account?", style: TextStyle(color: Colors.grey)),
                TextButton(onPressed: () {Navigator.pushNamed(context, "/login");}, child: Text("Login", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, decoration: TextDecoration.underline, decorationColor: Theme.of(context).colorScheme.onPrimary),))
              ],
            ),
          ),
        )
    );
  }
}