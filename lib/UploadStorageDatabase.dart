import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ColorsFile.dart';

class UploadStorageDatabase extends StatefulWidget {
  const UploadStorageDatabase({super.key});

  @override
  State<UploadStorageDatabase> createState() => _UploadStorageDatabase();
}

class _UploadStorageDatabase extends State<UploadStorageDatabase> {
  late final pickedImage;
  late bool ispickedImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(leading: Icon(Icons.keyboard_arrow_left_rounded)),
      body: Center(
          child: Column(
        children: [
          //UPLOAD IMAGE
          ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: Text(" UPLOAD FILE")),
          ispickedImage
              ? kIsWeb
                  ? Image(image: FileImage(pickedImage))
                  : Image.file(pickedImage)
              : Container(color: ColorsFile.ShadePrimary)
        ],
      )),
    );
  }

  void uploadImage() async {
    if (!kIsWeb) {
      print("storage=>PlatForm Android IOS");
      final _picker = ImagePicker();
      var image = await _picker.pickImage(source: ImageSource.gallery);
      File imageFile = File(image!.path);
      print("storage=>imageFile=>$imageFile");
      setState(() {
        pickedImage = imageFile;
        ispickedImage = true;
      });
      FirebaseStorage storage = FirebaseStorage.instance;
      var url;
      try {
        Reference ref =
            storage.ref().child("image1" + DateTime.now().toString());
        UploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.whenComplete(() {
          url = ref.getDownloadURL();
        }).catchError((onError) {
          print("storage=>onError=>$onError");
        });
      } catch (e) {
        print("storage=>error>getImage=>$e");
      }
    } else {
      try {
        final _picker = ImagePicker();

        var image = await _picker.pickImage(source: ImageSource.gallery);
        File imageFile = File(image!.path);
        print("storage=>imageFile=>$imageFile");
        setState(() {
          pickedImage = imageFile;
          ispickedImage = true;
        });
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference =
            storage.ref().child("image1" + DateTime.now().toString());
        print("storage=>163");
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': image.path},
        );

        UploadTask uploadTask =
            storageReference.putData(await image.readAsBytes(), metadata);
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

        print("storage=>179");

      } catch (e) {
        print('storage=>error in uploading image for : ${e.toString()}');
      }
    }
  }
}
