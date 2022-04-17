import 'package:flutter/material.dart';
import 'package:meta_transfer/components/custom_input.dart';
import 'package:meta_transfer/components/login_button.dart';
import 'package:meta_transfer/constants/my_colors.dart';
import 'package:meta_transfer/pages/home_page.dart';
import 'package:meta_transfer/db_handler.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Image.asset('assets/app_logo.png'),
                ),
                CustomInput(
                  inputType: TextInputType.emailAddress,
                  hintText: "type your email",
                  onChange: (str) {
                    email = str;
                  },
                ),
                /*CustomInput(
                  hintText: "type your username",
                  onChange: (str) {

                  },
                ),
                CustomInput(
                  inputType: TextInputType.phone,
                  hintText: "type your phone",
                  onChange: (str) {},
                ),
                */
                CustomInput(
                  hintText: "type your Password",
                  onChange: (str) {
                    password = str;
                  },
                  isPassword: true,
                ),
                Builder(
                  builder: (context) => LoginButton(
                    title: "SignUp",
                    TextColor: Colors.white,
                    onPressed: () async {
                      String result = await DBHandler.signUp(email, password);
                      if (result.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen()));
                      } else {
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
                    backgroundColor: Colors.blue,
                  ),
                ),
                TextButton(
                  child: Text(
                    "back to Login?",
                    style: KRegularWhiteText,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
