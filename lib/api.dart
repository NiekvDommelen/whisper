  Future<bool> signupUser(String username, String email, String password) async {
    String address = "${_baseURL}signup";
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
    var $data = jsonDecode(response.body);
    if($data["success"]?? false == true){
      bool login = await loginUser(username, password);
      if(login){
        return true;
      }else{
        return false;
      }

    }else{
      return false;
    }
  }

