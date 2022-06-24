import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/screen/login_page.dart';
import 'package:seip_day50/widget/brand_colors.dart';
import 'package:seip_day50/widget/custom_TextField.dart';
import 'package:seip_day50/widget/widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {



  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  bool isLoading = false;
  getRegister() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, dynamic>();
    map["name"] = nameController.text.toString();
    map["email"] = emailController.text.toString();
    map["password"] = passwordController.text.toString();
    map["password_confirmation"] = confirmPasswordController.text.toString();
    var responce = await http.post(
      Uri.parse("$uri/create/new/admin"),
      body: map,
      headers: CustomHttpRequest.defaultHeader,
    );
    print("${responce.body}");
    var data = jsonDecode(responce.body);
    if (responce.statusCode == 201) {
      showInToast("Registation Successful");
    } else {
      showInToast("${data["errors"]["email"]}");
    }

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading == true,
        opacity: 0.0,
        progressIndicator: spinkit,
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 50,left: 8,right: 8,bottom: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    CircleAvatar(
                      backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyqElvUCSdh7IgSMn071t53-0ceEGGVuXI1g&usqp=CAU",),
                      radius: 40,
                    ),


                    SizedBox(height: 30,),


                    CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name Required";
                        }
                      },
                      controller: nameController,
                      hintText: "Enter your Name",
                    ),




                    CustomTextField(
                      validator: (value){
                        if(!value!.contains("@")){
                          return "Invalid Email";
                        }else if(!value.contains("com")){
                          return "Invalid Email";
                        }
                      },
                      controller: emailController,
                      hintText: "Email",
                    ),




                    CustomTextField(
                      //obscureText: _isObsecure,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Required";
                        }

                        if (value.length > 15) {
                          return "Password is too long";
                        }

                        if (value.length < 3) {
                          return "Password is too short";
                        }
                      },
                      controller: passwordController,
                      hintText: "Password",
                    ),



                    CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Required";
                        }

                        if (value.length > 15) {
                          return "Password is too long";
                        }

                        if (value.length < 3) {
                          return "Password is too short";
                        }
                        if(passwordController.value == confirmPasswordController.value){
                          print("Password Match");
                          //return ""
                        }
                        else{
                          print("Password not Match");
                          return "Password not Match";
                        }
                      },

                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                    ),
                    SizedBox(height: 30,),
                    RaisedButton.icon(
                      onPressed: (){
                        print('Sign Up Button Clicked.');
                        if (_formKey.currentState!.validate()) {
                          getRegister();
                          Future.delayed(Duration(seconds: 3), () {
                            //Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                          });

                          //print("Successful");
                        } else {
                          print("Something wrong");
                        }
                        //settingData();

                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 50,top: 10,bottom: 10),
                        child: Text('Sign Up', style: TextStyle(fontSize:20, color: Colors.amber, letterSpacing: .5),),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 50,right: 10,top: 10,bottom: 10),
                        child: Icon(Icons.login_rounded, color:Colors.amber,),
                      ),
                      textColor: Colors.white,
                      splashColor: Colors.red,
                      color: Colors.lightBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
