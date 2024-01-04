import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:trackofyapp/Screens/OnboardingScreen/ForgotPassword.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';
import 'package:trackofyapp/Widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    SmartDialog.showLoading(msg: "Loading...");
    // Send a POST request to the API endpoint
    final response = await ApiService.login(username, password);
    SmartDialog.dismiss();
    if (response) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  bool _isObscure = true;
  bool isChecked = false;

  @override
  void initState() {
    _usernameController.text = "tarun_01";
    _passwordController.text = "12345";
    // _usernameController.text = "dps_faridabad";
    // _passwordController.text = "12345";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0973a3),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, bottom: 16, left: 10, right: 10),
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.blue.shade200,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.6,
                    0.9,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Material(
                          elevation: 5,
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: Text(
                                "Back",
                                style: TextStyle(
                                    color: ThemeColor.secondarycolor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.size.width * 0.10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: Image.asset(
                            "assets/images/logo_color.png",
                            height: Get.size.height * 0.09,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          SizedBox(height: Get.size.height * 0.13),
                          //username field
                          Container(
                            color: ThemeColor.primarycolor,
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/username_img.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 04),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: TextFormField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            isDense: true,
                                            labelText: "Username*",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //Password field
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              color: ThemeColor.primarycolor,
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/password_img.png",
                                      height: 40,
                                      width: 40,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 04),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: TextFormField(
                                            obscureText: _isObscure,
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              isDense: true,
                                              labelText: "Password*",
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              suffixIcon: IconButton(
                                                  icon: Icon(
                                                    _isObscure
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isObscure = !_isObscure;
                                                    });
                                                  }),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() => isChecked = value!);
                                },
                                activeColor: ThemeColor.greycolor,
                                checkColor: Colors.white,
                              ),
                              Text(
                                "I accept the terms and conditions.",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.greycolor,
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: _submitForm,
                              // onTap: (){
                              //   login(emailController.text.toString(), passwordController.text.toString());
                              // },
                              child: Center(child: Text('Login'))),
                          // materialButton(context, () {
                          //
                          //   Get.to(()=> HomeScreen());
                          //   print('Login Sucessfull');
                          // }, "LOGIN", ThemeColor.primarycolor),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => ForgotPassword());
                                  },
                                  child: Text(
                                    "Forgot Password ?",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          materialButton2(
                              context,
                              () {},
                              "READ TERMS AND CONDITIONS",
                              Colors.grey.shade400,
                              Get.size.width * 0.95,
                              Get.size.height * 0.07),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Text(
                              "App Version 3.048",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Developed and Designed by trackofy team",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          SizedBox(
                            height: Get.size.height * 0.20,
                          )
                        ],
                      ),
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
