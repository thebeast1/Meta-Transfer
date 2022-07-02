import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta_transfer/components/custom_input.dart';
import 'package:meta_transfer/components/shape_painter.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/db_handler.dart';
import 'package:meta_transfer/pages/login_page.dart';
import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name, cardNum;
  double balance;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  String imageUrl = "";

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user Or update the user data.

    loadingIndicator(1);
    await _users.doc(DBHandler.currentUser.email).set({
      'email': DBHandler.currentUser.email,
      'name': name,
      'cardNum': cardNum,
      'balance': balance,
      'points': DBHandler.currentUser.points,
      'profilePic': imageUrl
    });
    loadingIndicator(2);
  }

  loadingIndicator(int isLoading) {
    if (isLoading == 1)
      return showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
    else if (isLoading == 2) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    name = DBHandler.currentUser.name;
    cardNum = DBHandler.currentUser.cardNum;
    balance = DBHandler.currentUser.balance;
    imageUrl = DBHandler.currentUser.imageUrl;
  }

  @override
  void dispose() {
    super.dispose();
    didChangeDependencies();
  }

  uploadImage(File image) async {
    final _firebaseStorage = FirebaseStorage.instance;

    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('profile_pics/${DBHandler.currentUser.email}')
            .putFile(image);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: blackColorBG,
      key: _scaffoldKey,
      body: SafeArea(
        child: CustomPaint(
          painter: ShapePainter(),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (context) => RaisedButton.icon(
                          onPressed: () async {
                            bool result = await DBHandler.signOut();
                            if (result)
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                  (Route<dynamic> route) => false);
                            else {
                              final snackBar = SnackBar(
                                content: Text("Something went wrong!"),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          },
                          color: buttonNextColorBG1,
                          elevation: 10,
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        title: "Choose Image Source:",
                        animType: AnimType.BOTTOMSLIDE,
                        desc: "",
                        btnOk: IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () async {
                            File image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);
                            Navigator.pop(context);
                            loadingIndicator(1);
                            await uploadImage(image);
                            print("!!!!! image Path:$imageUrl");
                            setState(() {});
                            loadingIndicator(2);
                          },
                        ),
                        btnCancel: IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: () async {
                            File image = await ImagePicker.pickImage(
                                source: ImageSource.camera);
                            Navigator.pop(context);
                            loadingIndicator(1);
                            await uploadImage(image);
                            print("!!!!! image Path:$imageUrl");
                            setState(() {});
                            loadingIndicator(2);
                          },
                        ),
                      )..show();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .14),
                      height: 100,
                      width: 100,
                      child: imageUrl.isEmpty
                          ? Center(
                              child: Text(
                                DBHandler.currentUser.email[0].toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: blueColorBG2,
                              offset: Offset(2, 3),
                              spreadRadius: 1,
                              blurRadius: 5)
                        ],
                        color: buttonNextColorBG1,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      DBHandler.currentUser.email,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 3),
                            spreadRadius: 1,
                            blurRadius: 5)
                      ],
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  CustomInput(
                    onChange: (str) {
                      name = str;
                    },
                    hintText: DBHandler.currentUser.name == "unknown"
                        ? "Type Your Name.."
                        : DBHandler.currentUser.name,
                  ),
                  CustomInput(
                    inputType: TextInputType.number,
                    onChange: (str) {
                      cardNum = str;
                    },
                    hintText:
                        DBHandler.currentUser.cardNum == "××××××××××××××××"
                            ? "Type Your Card Number.."
                            : DBHandler.currentUser.cardNum,
                  ),
                  CustomInput(
                    inputType: TextInputType.number,
                    onChange: (str) {
                      balance = double.parse(str);
                    },
                    hintText: DBHandler.currentUser.balance == 0
                        ? "\$ Type Your Balance.."
                        : "\$ ${DBHandler.currentUser.balance}",
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      if (cardNum.length == 16 &&
                          balance <= 1000000 &&
                          balance >= 0 &&
                          name.isNotEmpty)
                        addUser();
                      else {
                        String result = "the balance must be less than 1000000";
                        if (cardNum.length != 16 && name.length == 0)
                          result = "fill the data correctly";
                        else if (cardNum.length != 16)
                          result = "Your card number must be 16 number";
                        else if (name.length == 0)
                          result = "please enter Your name";

                        final snackBar = SnackBar(
                          content: Text("$result"),
                        );
                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      height: 40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(2, 3),
                              spreadRadius: 1,
                              blurRadius: 5),
                        ],
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }
}
