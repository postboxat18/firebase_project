import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ColorsFile.dart';

class UploadRealtimeDatabase extends StatefulWidget {
  const UploadRealtimeDatabase({super.key});

  @override
  State<UploadRealtimeDatabase> createState() => _UploadRealtimeDatabaseState();
}

class _UploadRealtimeDatabaseState extends State<UploadRealtimeDatabase> {
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
  final TextEditingController ageController = TextEditingController();
  late bool validatorName = true;
  late bool validatorAge = true;

  late String ageErr = "Age Field Can't Be Empty";
  late String nameErr = "Name Field Can't Be Empty";

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
      appBar: AppBar(leading: Icon(Icons.keyboard_arrow_left_rounded)),
      body: Center(
          child: Column(
        children: [

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
          //AGE
          Padding(
              padding: EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 0),
              child: TextField(
                controller: ageController,
                textInputAction: TextInputAction.done,
                  inputFormatters: [],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    validatorAge = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Age",
                    errorText: validatorAge ? null : ageErr,

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
          //UPLOAD IMAGE
          ElevatedButton(
              onPressed: () {
                isLoading = true;

                if (validatorAge && validatorName) {
                  uploadDatabase(
                      nameController.text.trim(), ageController.text.trim());
                } else if (!validatorName) {
                  setState(() {
                    isLoading = false;
                    nameErr = "Name Field Can't be Empty";
                    validatorName = false;
                  });
                } else if (!validatorAge) {
                  setState(() {
                    isLoading = false;
                    ageErr = "Age Field Can't be Empty";
                    validatorAge = false;
                  });
                }
              },
              child: Text("UPLOAD DATABASE")),
          if (isLoading) ...[
            Padding(
                padding:
                    EdgeInsets.fromLTRB(paddingWidth, 15, paddingWidth, 15),
                child: CircularProgressIndicator(
                  color: ColorsFile.Secondary,
                ))
          ]
        ],
      )),
    );
  }

  void uploadDatabase(String name, String age) {
    FirebaseDatabase.instance
        .ref()
        .child("users")
        .push()
        .set({"name": name, "age": age});
  }
}
