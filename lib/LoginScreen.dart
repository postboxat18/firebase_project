library firebase_project;
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ColorsFile.dart';
import 'Home.dart';
import 'SignUp.dart';
import 'UtilsPreference.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsFile.Secondary),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  //Tablet Or Phone
  late bool isTab;
  late double height;
  late double width;
  late double paddingHeight;
  late double paddingWidth;

  //CARD RADIUS
  late double cardR1 = 12;
  late double cardR2 = 5;
  late double cardR3 = 50;

  //Phone
  late double textP1 = 14;
  late double textP2 = 12;
  late FontWeight weightW1 = FontWeight.w700;
  late FontWeight weightW2 = FontWeight.w600;
  late FontWeight weightW3 = FontWeight.w400;

  //Tab
  late double textT1 = 20;
  late double textT2 = 14;
  late double textT3 = 12;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late bool validatorUsr = true;
  late bool validatorPwd = true;
  late String usrErr = "Value Can't Be Empty";
  late String pwdErr = "Value Can't Be Empty";
  late bool success = false;
  late String userEmail = "";
  late bool visibleEye = true;
  late bool isLoading = false;
  late bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    //print(width);
    height = MediaQuery.of(context).size.height;
    //print(height);
    paddingWidth = (width * 0.1);
    paddingHeight = (height * 0.15);
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    isTab = data.size.shortestSide < 600 ? false : true;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //LOGIN
          Padding(
            padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
            child: Text(
              "Login",
              style: TextStyle(
                  color: ColorsFile.BlackLogin,
                  fontWeight: weightW1,
                  fontSize: isTab ? textT1 : textP1),
            ),
          ),
          //EMAIL
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
              child: TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    validatorUsr = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Email",
                    errorText: validatorUsr == true ? null : usrErr,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: ColorsFile.Secondary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: ColorsFile.Gray2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: ColorsFile.Red),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cardR2))),
              )),
          //PASSWORD
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 15),
              child: TextField(
                obscureText: visibleEye,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    validatorPwd = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                    errorText: validatorPwd == true ? null : pwdErr,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: ColorsFile.Secondary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: ColorsFile.Gray2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: ColorsFile.Red),
                    ),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cardR2))),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // REMEMBER ME
                  Row(
                    children: [
                      //CHECK BOX
                      Checkbox(
                        value: isRememberMe,
                        side: MaterialStateBorderSide.resolveWith((states) =>
                            BorderSide(
                                color: isRememberMe
                                    ? Colors.transparent
                                    : ColorsFile.Secondary,
                                width: 2)),
                        onChanged: (value) {
                          setState(() {
                            isRememberMe = value!;
                          });
                        },
                      ),
                      Text(
                        "Remember Me",
                        style: TextStyle(
                            fontWeight: weightW1,
                            fontSize: isTab ? textT1 : textP1,
                            color: ColorsFile.Secondary),
                      )
                    ],
                  ),

                  //FORGOT PASSWORD
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          paddingWidth, 15, paddingWidth, 15),
                      child: TextButton(
                          onPressed: () async {
                            if (emailController.text
                                .trim()
                                .toString()
                                .isNotEmpty) {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: emailController.text
                                            .trim()
                                            .toString());
                                print("resendEmailPassword=>success");
                              } catch (e) {
                                print("resendEmailPassword=>$e");
                              }
                              Fluttertoast.showToast(
                                msg: "ResetPassword Send To Your Mail",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: ColorsFile.Secondary,
                                fontSize: isTab ? textT1 : textP1,
                                fontWeight: weightW1),
                          ))),
                ],
              )),
          //LOGIN BTN
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
              child: SizedBox(
                width: width * 3,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cardR2)),
                        backgroundColor: ColorsFile.Primary),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      if (validatorPwd && validatorUsr) {
                        LoginScreenFunc(emailController.text.trim(),
                            passwordController.text.trim(), isRememberMe);
                      } else if (!validatorUsr) {
                        setState(() {
                          isLoading = false;

                          usrErr = "Email Can't be Empty";
                          validatorUsr = false;
                        });
                      } else if (!validatorPwd) {
                        setState(() {
                          isLoading = false;

                          pwdErr = "Password Can't be Empty";
                          validatorPwd = false;
                        });
                      }
                    },
                    child: Text("Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isTab ? textT2 : textP2))),
              )),
          //CREATE A ACCOUNT
          isLoading
              ? Padding(
                  padding:
                      EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 15),
                  child: CircularProgressIndicator(
                    color: ColorsFile.Secondary,
                  ))
              : Padding(
                  padding:
                      EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 15),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                      },
                      child: Text(
                        "Create a Account",
                        style: TextStyle(
                            color: ColorsFile.Secondary,
                            fontSize: isTab ? textT1 : textP1,
                            fontWeight: weightW1),
                      ))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void LoginScreenFunc(String email, String password, bool isRememberMe) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print("LoginScreenFunc");

      UtilsPreference.setString(UtilsPreference.USER_EMAIL, email);
      UtilsPreference.setString(UtilsPreference.PASSWORD, password);
      UtilsPreference.setString(
          UtilsPreference.REMEMBER, isRememberMe.toString());
      setState(() {
        isLoading = false;
      });
      print(userCredential);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
          usrErr = "No user found for that email.";
          validatorUsr = false;
        });
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() {
          isLoading = false;
          pwdErr = "Wrong Password provided for that user.";
          validatorPwd = false;
        });
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }
}
