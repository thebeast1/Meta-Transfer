import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta_transfer/components/custom_input.dart';
import 'package:meta_transfer/components/shape_painter.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/db_handler.dart';
import 'package:meta_transfer/pages/login_page.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void dispose() {
    super.dispose();
  }

  String name, cardNum;
  double balance;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user Or update the user data.
    if (cardNum.length == 16 &&
        balance <= 1000000 &&
        balance >= 0 &&
        name.isNotEmpty)
      await _users.doc(DBHandler.currentUser.email).set({
        'email': DBHandler.currentUser.email,
        'name': name,
        'cardNum': cardNum,
        'balance': balance,
        'points': 0
      });
  }

  @override
  void initState() {
    super.initState();
    name = DBHandler.currentUser.name;
    cardNum = DBHandler.currentUser.cardNum;
    balance = DBHandler.currentUser.balance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: blackColorBG,
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
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .14),
                    padding: EdgeInsets.symmetric(horizontal: 34, vertical: 28),
                    child: Text(
                      DBHandler.currentUser.email[0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 22),
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
                    onTap: addUser,
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
