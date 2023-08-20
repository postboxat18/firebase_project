import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:string_extensions/string_extensions.dart';

import 'ColorsFile.dart';
import 'LoginScreen.dart';
import 'UploadRealtimeDatabase.dart';
import 'UploadStorageDatabase.dart';
import 'UtilsPreference.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsFile.Primary),
        useMaterial3: true,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
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
  late TabController tabController;
  late double statusBarHeight;
  late String displayName="";
  late String displayEmail="";
  late String displayPhotoUrl="";

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    intialFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).viewPadding.top;

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
      backgroundColor: ColorsFile.bgClr,
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Navigation(),
      body: Column(children: [
        TabBar(
            controller: tabController,
            isScrollable: false,
            labelColor: ColorsFile.white,
            indicatorPadding:
                EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
            indicator: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardR2)),
                color: ColorsFile.Secondary),
            labelStyle: TextStyle(
              fontWeight: weightW1,
            ),
            unselectedLabelColor: ColorsFile.Gray2,
            unselectedLabelStyle: TextStyle(
              fontWeight: weightW3,
            ),
            tabs: [
              Tab(
                child: SizedBox(
                    width: width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "RealTime DataBase",
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => UploadRealtimeDatabase(),
                              ));
                            },
                            icon: const Icon(
                              Icons.add_outlined,
                              color: Colors.black,
                            ))
                      ],
                    )),
              ),
              Tab(
                child: SizedBox(
                    width: width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Storage DataBase",
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => UploadStorageDatabase(),
                              ));
                            },
                            icon: const Icon(
                              Icons.add_outlined,
                              color: Colors.black,
                            ))
                      ],
                    )),
              ),
            ]),
        Expanded(
            child: TabBarView(controller: tabController, children: [
          //REALTIME DATA BASE
          RefreshIndicator(
            child: FutureBuilder(
              future: LoadRealTime(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<RealTimeDatabase> realTimeDataList = [];
                  realTimeDataList = snapshot.data?.value;
                  return ListView.builder(
                    itemCount: realTimeDataList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                //AGE
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Age:",
                                        style:
                                            TextStyle(color: ColorsFile.Gray2),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(realTimeDataList[index]
                                          .age
                                          .toString()),
                                    ),
                                  ],
                                ),
                                //NAME
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Name:",
                                        style:
                                            TextStyle(color: ColorsFile.Gray2),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(realTimeDataList[index]
                                          .name
                                          .toString()),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    },
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            onRefresh: () => Navigator.of(context, rootNavigator: true)
                .pushReplacement(MaterialPageRoute(
              builder: (context) => Home(),
            )),
          ),
          //STORAGE DATA BASE
          RefreshIndicator(
            child: FutureBuilder(
              future: LoadStorage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> image = snapshot.data![index];
                      return Card(
                        color: ColorsFile.white,
                        margin: EdgeInsets.fromLTRB(
                            paddingWidth, 15, paddingWidth, 0),
                        child: Column(children: [
                          Row(
                            children: [
                              //CIRCLE
                              Container(
                                padding: EdgeInsets.all(15),
                                height: 150,
                                width: 150,
                                child: Image.network(image['url'].toString()),
                              ),
                              //NAME
                              Flexible(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 15, 15, 0),
                                child: Text(image['path'],
                                    style: TextStyle(
                                        fontSize: isTab ? textT1 : textP1,
                                        color: ColorsFile.Secondary,
                                        fontWeight: weightW1),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ))
                            ],
                          ),

                          //DESC
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: Text(
                              image['description'],
                              style: TextStyle(
                                  fontSize: isTab ? textT2 : textP2,
                                  color: ColorsFile.BlackLogin,
                                  fontWeight: weightW3),
                            ),
                          )
                        ]),
                      );
                    },
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            onRefresh: () => Navigator.of(context, rootNavigator: true)
                .pushReplacement(MaterialPageRoute(
              builder: (context) => Home(),
            )),
          ),
        ]))
      ]),
    );
  }

  Navigation() {
    return Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, statusBarHeight),
          child: Column(children: [
            Row(
              children: [
                //CIRCLE
                Container(
                  height: 70,
                  width: 50,
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: ColorsFile.ShadeSecondary),
                  child: displayPhotoUrl.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(displayName[0].capitalize.toString()))
                      : Padding(
                          padding: EdgeInsets.all(0),
                          child: Image.network(displayPhotoUrl,fit: BoxFit.fill,)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //NAME
                    Padding(
                      padding: EdgeInsets.fromLTRB(15,15,15,5),
                      child: Text(
                        displayName.capitalize.toString(),
                        style: TextStyle(
                            color: ColorsFile.BlackLogin, fontWeight: weightW1),
                      ),
                    ),
                    //EMAIL
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Text(
                        displayEmail,
                        style: TextStyle(
                            color: ColorsFile.Gray2, fontWeight: weightW3),
                      ),
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextButton(
                  onPressed: () {
                    UtilsPreference.setString(
                        UtilsPreference.REMEMBER, "false");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        color: ColorsFile.Primary,
                        fontWeight: weightW1,
                        fontSize: isTab ? textT1 : textP1),
                  )),
            )
          ]),
        ));
  }

  Future<List<Map<String, dynamic>>> LoadStorage() async {
    List<Map<String, dynamic>> files = [];
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult result = await firebaseStorage.ref().list();
    List<Reference> allFiles = result.items;
    await Future.forEach(allFiles, (element) async {
      String fileUrl = await element.getDownloadURL();
      FullMetadata fileMeta = await element.getMetadata();
      files.add({
        "url": fileUrl,
        "path": element.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No Description'
      });
    });

    return files;
  }

  Future<MutableLiveData> LoadRealTime() async {
    Map<dynamic, dynamic>? map = {};
    List<dynamic> list = [];
    List<RealTimeDatabase> realTimeDataList = [];
    MutableLiveData liveData = MutableLiveData();
    FirebaseDatabase firebaseStorage = FirebaseDatabase.instance;
    DatabaseEvent result = await firebaseStorage.ref().child("users").once();
    map = result.snapshot.value as Map?;
    print("LoadRealTime=>map=>$map");
    map?.forEach((key, value) {
      list.add(value);
    });
    try {
      list.forEach((element) {
        RealTimeDatabase database =
            RealTimeDatabase(element["age"], element["name"]);
        realTimeDataList.add(database);
      });
    } catch (e) {
      print("LoadRealTime=>error=>$e");
    }
    print("LoadRealTime=>database=>$realTimeDataList");

    liveData.value = realTimeDataList;

    return liveData;
  }

  void UploadReatimeDatabase() {}

  void intialFunc() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;

      if (user != null) {
        displayName = user.displayName!;
        displayEmail = user.email!;
        displayPhotoUrl = user.photoURL!;
        setState(() {
          displayEmail;
          displayName;
          displayPhotoUrl;
        });
        print("Navigation=> $displayName $displayEmail $displayPhotoUrl");
      }
    } catch (e) {
      print("Navigation=>error=> $e");
    }
  }

/*void UploadStorageDatabase() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Card(
          color: Colors.white,
          child: Center(
              child: Column(
            children: [
              //UPLOAD IMAGE
              ElevatedButton(
                  onPressed: () {
                    uploadImage();
                  },
                  child: Text(" UPLOAD FILE")),
              pickedImage != null
                  ? kIsWeb
                      ? Image(image: FileImage(pickedImage))
                      : Image.file(pickedImage)
                  : Container(color: ColorsFile.ShadePrimary)
            ],
          )),
        );
      },
    );
  }*/
}

class RealTimeDatabase {
  final String age;
  final String name;

  RealTimeDatabase(this.age, this.name);

  @override
  String toString() {
    // TODO: implement toString
    return "age=>$age name=>$name";
  }
}
