import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta_transfer/components/custom_input.dart';
import 'package:meta_transfer/components/login_button.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/pages/home_page.dart';
import 'package:meta_transfer/pages/signup_page.dart';
import 'package:meta_transfer/db_handler.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            backgroundColor: blackColorBG,
            title: new Text(
              'Are you sure?',
              style: TextStyle(color: Colors.white),
            ),
            content: new Text('Do you want to exit an App',
                style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: BackgroundGradientM2,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Image.asset('assets/app_logo.png'),
                  ),
                  CustomInput(
                    bgColor: fieldColorBG6,
                    hintText: "type your email",
                    onChange: (str) {
                      email = str;
                    },
                  ),
                  CustomInput(
                    hintText: "type your Password",
                    onChange: (str) {
                      password = str;
                    },
                    isPassword: true,
                  ),
                  Builder(
                    builder: (context) => LoginButton(
                      title: "Login",
                      TextColor: textBlueColorBG1,
                      onPressed: () async {
                        String result = await DBHandler.signIn(email, password);
                        if (result.isEmpty)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomeScreen() //Home()
                                  ));
                        else {
                          print("@@@@@@@@@@@@@@@@@@@@");

                          final snackBar = SnackBar(
                            content: Text(result),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      backgroundColor: buttonNextColorBG1,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      "create new account?",
                      style: KRegularWhiteText,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Register()));
                    },
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

class TitleName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: Image.asset("assets/small_logo.png"),
    );
    /*Row(
      children: [
        
        Icon(
          Icons.account_balance_wallet_outlined,
          color: titleBlueColorBG2,
        ),
        SizedBox(
          width: 4,
        ),
        Transform.translate(
          offset: Offset(1, -2),
          child: Transform.rotate(
            angle: -0.8,
            child: Text(
              'e ',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleBlueColorBG2),
            ),
          ),
        ),
        Text(
          "-wallet",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleBlueColorBG2),
        ),
      ],
    );*/
  }
}
