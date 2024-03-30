import 'package:bloc/bloc.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ColorsFile.dart';
import 'Bloc/upload_real_time_bloc.dart';
import 'package:bloc/bloc.dart';

class UploadRealTimeBlocPattern extends StatefulWidget {
  const UploadRealTimeBlocPattern({super.key});

  @override
  State<UploadRealTimeBlocPattern> createState() =>
      _UploadRealTimeBlocPatternState();
}

class _UploadRealTimeBlocPatternState extends State<UploadRealTimeBlocPattern> {
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

  late UploadRealTimeBloc uploadRealTimeBlocPattern = UploadRealTimeBloc();
  late UploadRealTimeBloc uploadRealTimeLoadBlocPattern = UploadRealTimeBloc();

  @override
  void initState() {
    uploadRealTimeLoadBlocPattern.add(UploadRealTimeLoadEvent());
    super.initState();
  }

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
    return BlocConsumer(
      bloc: uploadRealTimeBlocPattern,
      builder: (context, state) {
        return buildWidget(context);
      },
      listener: (context, state) {},
    );
  }

  getExistingData(UploadRealTimeLoadState state) {
    return FirebaseDatabaseListView(
      query: state.ref,
      itemBuilder: (context, doc) {
        Map user = doc.value as Map;
        return Card(
          child: Column(
            children: [
              Row(
                children: [
                  Text("AGe:"),
                  Text(user['age']),
                ],
              ),
              Row(
                children: [
                  Text("NAme:"),
                  Text(user['name']),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildWidget(BuildContext context) {
    return BlocBuilder(
      bloc: uploadRealTimeLoadBlocPattern,
      builder: (context, state) {
        if (state is UploadRealTimeLoadState) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(leading: Icon(Icons.keyboard_arrow_left_rounded)),
            body: Center(
                child: Column(
              children: [
                //existing data
                getExistingData(state),
              ],
            )),
          );
        } else {
          return Container(
            color: Colors.green,
          );
        }
      },
    );
  }
}
