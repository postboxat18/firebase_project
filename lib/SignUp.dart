import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File, Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import 'ColorsFile.dart';
import 'LoginScreen.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsFile.Secondary),
        useMaterial3: true,
      ),
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late bool validatorUsr = true;
  late bool validatorPwd = true;
  late bool validatorName = true;
  late bool validatorNum = true;
  late File imageFile;
  late bool isImageFile = false;
  late String usrErr = "Value Can't Be Empty";
  late String pwdErr = "Value Can't Be Empty";
  late String nameErr = "Value Can't Be Empty";
  late String phoneNumErr = "Value Can't Be Empty";
  late bool success = false;
  late bool visibleEye = true;
  late bool isLoading = false;

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
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SignUp
          Padding(
            padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
            child: Text(
              "SignUp",
              style: TextStyle(
                  color: ColorsFile.BlackLogin,
                  fontWeight: weightW1,
                  fontSize: isTab ? textT1 : textP1),
            ),
          ),
          //IMAGE
          InkWell(
            child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: isImageFile
                    ? kIsWeb
                        ? Image(image: FileImage(File(imageFile.path)))
                        : Image.file(File(imageFile.path))
                    : Container(color: ColorsFile.ShadePrimary)),
            onTap: () async {
              final _picker = ImagePicker();
              var image = await _picker.pickImage(source: ImageSource.gallery);
              imageFile = File(image!.path);
              //imageFile = image;
              print("upload=>imageFile=>${imageFile.path}");
              setState(() {
                imageFile;
                isImageFile = true;
              });
            },
          ),
          //NAME
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
              child: TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    validatorName = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Name",
                    errorText: validatorName ? null : nameErr,
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
          //EMAIL
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
              child: TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    usrErr = 'Enter Valid Email';
                    validatorUsr = false;
                  } else {
                    usrErr = '';
                    validatorUsr = true;
                  }
                  setState(() {
                    validatorUsr;
                    usrErr;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Email",
                    errorText: validatorUsr ? null : usrErr,
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
          //PHONE NUMBER
          /*Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
              child: TextField(
                controller: phoneNumController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = RegExp(pattern);
                  if (value.isEmpty) {
                    phoneNumErr = 'Please enter mobile number';
                    validatorNum = false;
                  } else if (!regExp.hasMatch(value)) {
                    phoneNumErr = 'Please enter valid mobile number';
                    validatorNum = false;
                  } else {
                    phoneNumErr = '';
                    validatorNum = true;
                  }
                  setState(() {
                    validatorNum;
                    phoneNumErr;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    errorText: validatorNum ? null : phoneNumErr,
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
              )),*/
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
                    errorText: validatorPwd ? null : pwdErr,
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
          //SignUp BTN
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
                      if (validatorPwd &&
                          validatorUsr &&
                          validatorName &&
                          validatorNum) {
                        SignUpScreenFunc(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            nameController.text.trim(),
                            phoneNumController.text.trim(),
                            imageFile);
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
                      } else if (!validatorName) {
                        setState(() {
                          isLoading = false;
                          nameErr = "Name Field Can't be Empty";
                          validatorName = false;
                        });
                      } else if (!validatorNum) {
                        setState(() {
                          isLoading = false;
                          phoneNumErr = "Phone Number Field Can't be Empty";
                          validatorNum = false;
                        });
                      }
                    },
                    child: Text("SignUp",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isTab ? textT2 : textP2))),
              )),

          //Already Have A ACCOUNT
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
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text(
                        "Already Have a Account",
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

  void SignUpScreenFunc(
    String email,
    String password,
    String name,
    String phoneNumber,
    File imageFile,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      await user?.sendEmailVerification();
      await user?.updateDisplayName(name);
      //await user?.updatePhoneNumber(phoneNumber);

      uploadProfilePic(imageFile, user!.uid, user);
      print("SignUpScreenFunc");
      print(userCredential);
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          pwdErr = "The password provided is too weak.";
          validatorPwd = false;
          isLoading = false;
        });
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          usrErr = "The account already exists for that email.";
          validatorUsr = false;
          isLoading = false;
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void uploadProfilePic(File imageFile, String uid, User user) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String profileName = "profilePic_${uid}_${DateTime.now().toString()}";
    Reference ref = storage.ref().child(profileName);
    if (kIsWeb) {
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': imageFile.path},
      );

      UploadTask uploadTask =
          ref.putData(await imageFile.readAsBytes(), metadata);
      var imageUri;
      print("storage=>166");

      uploadTask.then((snapshot) => {
            Future.delayed(Duration(seconds: 1)).then((value) => {
                  snapshot.ref.getDownloadURL().then((dynamic uri) {
                    imageUri = uri;
                    print("storage=>172");

                    print('storage=>Download URL: ${imageUri.toString()}');
                  })
                })
          });
      print("storage=>url=>$imageUri");
      await user.updatePhotoURL(imageUri);
    } else {
      var url;
      try {
        TaskSnapshot uploadTask = await ref.putFile(imageFile);
        print("storage=>uploadTask=>${uploadTask}");
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        print("storage=>imageUrl=>$downloadUrl");
        await user.updatePhotoURL(downloadUrl);
      } catch (e) {
        print("storage=>error>Android&IOS=>getImage=>$e");
      }
    }
  }
}
