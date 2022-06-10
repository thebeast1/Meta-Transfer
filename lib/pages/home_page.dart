import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta_transfer/components/custom_input.dart';
import 'package:meta_transfer/components/login_button.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/db_handler.dart';
import 'package:meta_transfer/models/history_item.dart';
import 'package:meta_transfer/pages/bills_page.dart';
import 'package:meta_transfer/pages/login_page.dart';
import 'package:meta_transfer/pages/profile_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //this code for the qr scanning..
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  final CollectionReference _history =
      FirebaseFirestore.instance.collection('history');

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  final double fee = 1.00;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: BackgroundGradientM2,
          ),
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height * .1,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleName(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Profile()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffc7c7c7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: MediaQuery.of(context).size.height * .2,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(5, 7), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xff262626),
                    fieldColorBG6,
                    //Color(0xfff85d0d),
                  ],
                ),
              ),
              child: StreamBuilder(
                stream: _users
                    .where("email", isEqualTo: DBHandler.currentUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();

                  DocumentSnapshot documentSnapshot;
                  if (snapshot.data.docs.toString().length > 2) //
                  {
                    documentSnapshot = snapshot.data.docs[0];
                    DBHandler.currentUser.cardNum = documentSnapshot['cardNum'];
                    DBHandler.currentUser.balance = documentSnapshot['balance'];
                    DBHandler.currentUser.name = documentSnapshot['name'];
                  } else {
                    DBHandler.currentUser.cardNum = "××××××××××××××××";
                    DBHandler.currentUser.balance = 0.0;
                    DBHandler.currentUser.name = "unknown";
                  } //
                  String cardNum = DBHandler.currentUser.cardNum;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "\$${DBHandler.currentUser.balance}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          cardNum.substring(0, 4) +
                              "\t\t\t" +
                              cardNum.substring(4, 8) +
                              "\t\t\t" +
                              cardNum.substring(8, 12) +
                              "\t\t\t" +
                              cardNum.substring(12),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Text(
                        'xx/xx',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconItem(Icons.transit_enterexit, 'Send', 0, _sendMoney),
                  IconItem(Icons.transit_enterexit, 'Receive', 1, _receive),
                  IconItem(Icons.wysiwyg, 'Withdraw', 1, _withdrawMoney),
                  IconItem(Icons.receipt, 'Bills', 1, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => BillsPage()));
                  }),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    listOfHistory(),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget listOfHistory() {
    return Expanded(
      child: Container(
        child: StreamBuilder(
          stream: _history.orderBy("time", descending: false).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting)
              return Container(
              );

            return ListView.builder(
              itemCount: streamSnapshot.data.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data.docs[index];


                var item = HistoryItem(
                    documentSnapshot['time'],
                    documentSnapshot['amount'].toString(),
                    documentSnapshot['sender'],
                    documentSnapshot['receiver']);


                if (!(item.sender == DBHandler.currentUser.email ||
                    item.receiver == DBHandler.currentUser.email))
                  return Container();

                return listItem(
                  Icons.transit_enterexit,
                  item,
                );

              },
            );
          },
        ),
      ),
    );
  }

  Widget listItem(IconData icon, HistoryItem data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconDesign(icon, data.type),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  data.time,
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              data.amount,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  _receive() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "receive money with qr code",
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          children: [
            Container(
              height: 250,
              width: 230,
              child: QrImage(
                foregroundColor: Colors.amber,
                data: DBHandler.currentUser.email,
                version: QrVersions.auto,
                size: 200.0,
                padding: EdgeInsets.all(24),
              ),
            )
          ],
        );
      },
    );
  }

  _withdrawMoney() {
    showDialog(
      context: context,
      builder: (context) {
        String phone = "";
        String address = "";
        double amount = 0;
        return SimpleDialog(
          title: Text(
            "withdraw and receive the money at your door",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: blackColorBG,
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          children: [
            Text(
              "you will receive the money after 1 day work by trusted agent",
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber,
              ),
            ),
            CustomInput(
                inputType: TextInputType.phone,
                hintText: "Enter Your Phone number..",
                onChange: (t) {
                  phone = t;
                }),
            CustomInput(
                inputType: TextInputType.emailAddress,
                hintText: "Enter Your address..",
                onChange: (t) {
                  address = t;
                }),
            CustomInput(
                inputType: TextInputType.number,
                hintText: "how much money to recive",
                onChange: (t) {
                  amount = double.parse(t);
                }),
            LoginButton(
                title: "Send",
                TextColor: Colors.white,
                onPressed: () async {
                  double balance =
                      0.0; //the balance of the receiver to increase it and save it in his wallet again.
                  if (address.isNotEmpty &&
                      amount > 0 &&
                      phone.length == 11 &&
                      DBHandler.currentUser.balance - (amount + fee) >
                          0) // i have enough money.
                  {
                    //update my balance
                    _users.doc(DBHandler.currentUser.email).update({
                      'balance': DBHandler.currentUser.balance - (amount + fee),
                      // discount the transaction form the sender
                    }).then((value) {

                      String time = DateFormat.yMMMMEEEEd()
                          .add_Hms()
                          .format(DateTime.now());

                      print("!!!!!succeed $time ${DateTime.now()}");

                      _history
                          .add({
                            'sender': DBHandler.currentUser.email,
                            'receiver': address,
                            'amount': amount,
                            'time': time,
                          })
                          .then((value) => Navigator.pop(context))
                          .catchError((error) => AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Erorr',
                                desc: error,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show());

                    }).catchError((error) => AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Erorr',
                          desc: error,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        )..show());
                  }
                },
                backgroundColor: buttonNextColorBG2),
          ],
        );
      },
    );
  }

  _sendMoney() {
    showDialog(
      context: context,
      builder: (context) {
        String email = "";
        double amount = 0;
        bool visible = false;
        return SimpleDialog(
          title: Text(
            "Send Money to This Account",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: blackColorBG,
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          children: [
            StatefulBuilder(builder: (context, StateSetter setS) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: !visible,
                          child: Expanded(
                            child: CustomInput(
                                inputType: TextInputType.emailAddress,
                                hintText: "Enter the E-mail..",
                                onChange: (t) {
                                  email = t;
                                }),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.qr_code_outlined,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setS(() {
                                visible = !visible;
                                if (!visible) {
                                  result = null;
                                  email = "";
                                }
                              });
                            }),
                      ],
                    ),
                    Visibility(
                      visible: visible,
                      child: Container(
                        height: 400,
                        width: 300,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 300,
                              width: 230,
                              child: QRView(
                                key: qrKey,
                                onQRViewCreated: (QRViewController controller) {
                                  this.controller = controller;
                                  controller.scannedDataStream
                                      .listen((scanData) {
                                    setS(() {
                                      result = scanData;
                                      email = result.code;
                                    });
                                  });
                                },
                              ),
                            ),
                            Center(
                              child: result == null
                                  ? Container()
                                  : Card(
                                      margin: const EdgeInsets.all(10),
                                      color: fieldColorBG6,
                                      child: ListTile(
                                        title: Text(
                                          result.code,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    CustomInput(
                        inputType: TextInputType.number,
                        hintText: "how much money",
                        onChange: (t) {
                          amount = double.parse(t);
                        }),
                    LoginButton(
                        title: "Send",
                        TextColor: Colors.white,
                        onPressed: () async {
                          double balance =
                              0.0; //the balance of the receiver to increase it and save it in his wallet again.
                          if (email.isNotEmpty &&
                              amount > 0 &&
                              email !=
                                  DBHandler.currentUser
                                      .email && // don't send money to yourself
                              DBHandler.currentUser.balance - (amount + fee) >
                                  0) // i have enough money.
                          {
                            //first get his old balance before transaction.
                            _users.where('email', isEqualTo: email).get().then(
                                (value) {
                              balance = value.docs[0].get('balance');
                              print("@@@@@@@@@@$balance");
                              //second update the old balance  with adding the new transaction to his balance.
                              _users.doc(email).update({
                                'balance': balance + amount,
                                // add his old balance to the sent money
                              }).then((value) {
                                print("!!!!!succeed");
                                //third update my balance
                                _users.doc(DBHandler.currentUser.email).update({
                                  'balance': DBHandler.currentUser.balance -
                                      (amount + amount*.01),
                                  // discount the transaction form the sender
                                }).then((value) {
                                  //final step make a history of this transaction.

                                  String time = DateFormat.yMMMMEEEEd()
                                      .add_Hms()
                                      .format(DateTime.now());
                                  print("!!!!!succeed $time ${DateTime.now()}");
                                  _history
                                      .add({
                                        'sender': DBHandler.currentUser.email,
                                        'receiver': email,
                                        'amount': amount,
                                        'time': time,
                                      })
                                      .then((value) => Navigator.pop(context))
                                      .catchError((error) => print(
                                          "!!!!!! Failed in the Final step $error"));
                                }).catchError((error) => print(
                                    "!!!!!! Failed in the third step $error"));
                              }).catchError((error) => print(
                                  "!!!!!!Failed in second step adding the balance to the receiver $error"));
                            }).catchError((error) => print(
                                "!!!!!!Failed in first step Email not found....$error"));
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              animType: AnimType.SCALE,
                              title: 'Info',
                              desc:
                                  "Enter the data correctly or check your balance",
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            )..show();
                          }
                          //Navigator.pop(context);
                        },
                        backgroundColor: buttonNextColorBG2),
                  ],
                ),
              );
            })
          ],
        );
      },
    ).whenComplete(() {
      controller.dispose();
    });
  }

  /* @override
  void reassemble() {
    super.reassemble();
    controller.pauseCamera();
  }
  */

  Widget IconItem(IconData icon, String text, int rotation, Function onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 60,
        width: 80,
        child: Column(
          children: [
            iconDesign(icon, rotation),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget iconDesign(IconData icon, int rotation) {
    return Container(
      margin: EdgeInsets.only(bottom: 4, left: 0),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
        color: titleBlueColorBG2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Transform.rotate(
        angle: rotation == 0 ? 3 : 0,
        child: Icon(
          icon,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
