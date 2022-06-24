import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/screen/registration_page.dart';
import 'package:seip_day50/tab_item/home_page.dart';
import 'package:seip_day50/tab_item/tab_menu.dart';
import 'package:seip_day50/widget/brand_colors.dart';
import 'package:seip_day50/widget/custom_TextField.dart';
import 'package:seip_day50/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String loginLink = "https://apihomechef.antopolis.xyz/api/admin/sign-in";

  late SharedPreferences sharedPreferences;


  // check use is login or not if login then goto next page and save user data and one time login
  isLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => TabMenu()));
    } else {
      print("Token is empty");
    }
  }

  getLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var map = Map<String, dynamic>();
    map["email"] = emailController.text.toString();
    map["password"] = passwordController.text.toString();
    var responce = await http.post(
      Uri.parse(loginLink),
      body: map,
    );
    if (responce.statusCode == 200) {
      showInToast("Login Succesfull");
      var data = jsonDecode(responce.body);
      setState(() {
        sharedPreferences.setString("token", data["access_token"]);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TabMenu()));

      });
      token = sharedPreferences.getString("token");

      print("token is $token");
    } else {
      showInToast("Invalid Email or Password");
    }
  }

  String? token;

  @override
  void initState() {
    // TODO: implement initState
    isLogin();
    super.initState();
  }
////
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading == true,
        opacity: 0.0,
        progressIndicator: CircularProgressIndicator(),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: emailController,
                hintText: "Enter your email",
              ),
              CustomTextField(
                controller: passwordController,
                hintText: "Enter your password",
              ),
              MaterialButton(
                onPressed: () {
                  getLogin();
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>TabMenu()));
                },
                color: Colors.orange,
                child: Text("Login"),
              ),





              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have Account?",style: TextStyle(color: Colors.black),),
                  SizedBox(width: 15,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                    },
                    child: Text("Sign Up",style: TextStyle(fontSize:15, color: Colors.amber, letterSpacing: .5),),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
