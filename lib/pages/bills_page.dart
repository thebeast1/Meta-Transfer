import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta_transfer/components/shape_painter.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/constants/strings.dart';
import 'package:meta_transfer/db_handler.dart';
import 'package:meta_transfer/models/bills.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {

  List<Bill> _bills = [
    Bill(billName1, 105.5, Icons.electrical_services_sharp),
    Bill(billName2, 50.5, Icons.opacity_outlined),
    Bill(billName3, 50.5, Icons.wifi),
    Bill(billName4, 1000, Icons.car_rental),
    Bill(billName5, 50, Icons.bubble_chart_outlined),
    Bill(billName6, 100.5, Icons.cast_for_education),
    Bill(billName7, 5.5, Icons.emoji_transportation_outlined),
  ];

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _history =
      FirebaseFirestore.instance.collection('history');

  _payBill(String address, double amount) {
    //update my balance
    if (address.isNotEmpty &&
        amount > 0 &&
        DBHandler.currentUser.balance - amount > 0) {
      // i have enough money.
      setState(() {
        DBHandler.currentUser.points++;
      });
      _users.doc(DBHandler.currentUser.email).update({
        'balance': DBHandler.currentUser.balance - amount,
        'points': DBHandler.currentUser.points
        // discount the transaction form the sender
      }).then((value) {
        String time = DateFormat.yMMMMEEEEd().add_Hms().format(DateTime.now());

        print("!!!!!succeed $time");
        _history.add({
          'sender': DBHandler.currentUser.email,
          'receiver': address,
          'amount': amount,
          'time': time,
        }).then((value) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Success',
            desc: 'The bill has been paid successfully',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        }).catchError((error) => AwesomeDialog(
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
            margin: EdgeInsets.all(15),
            color: blackColorBG,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.all(12),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "${DBHandler.currentUser.points} Points",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .14,
                      bottom: 12,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "pay Your Bills",
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
                  Container(
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * .6,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: _bills.length,
                      itemBuilder: (context, i) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(_bills[i].name),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  Text(
                                    _bills[i].cost.toString(),
                                  ),
                                  Expanded(child: Container()),
                                  // Press this button to edit a single product
                                  IconButton(
                                    icon: Icon(_bills[i].icon),
                                    onPressed: () {
                                      _payBill(_bills[i].name, _bills[i].cost);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
