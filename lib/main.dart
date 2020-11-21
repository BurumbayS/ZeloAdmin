import 'dart:convert';

import 'package:ZeloBusiness/service/Network.dart';
import 'package:ZeloBusiness/service/Storage.dart';
import 'package:ZeloBusiness/utils/alert-dialog.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/orders-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget _homePage = Container(
    color: Colors.white,
  );

  Future<void> checkAuthentication() async {
    String token = await Storage.itemBy('token');

    print(token);
    if (token == null) {
      setState(() {
        _homePage = WelcomePage();
      });
    } else {
      setState(() {
        _homePage = OrdersPage();
      });
    }

  }

  @override
  void initState() {
    super.initState();

    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: _homePage,
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {

  final _mailTextFieldController = TextEditingController();
  final _passwordTextFieldController = TextEditingController();

  bool _fieldsFilledCorrectly() {

    if (_mailTextFieldController.text != "" && _passwordTextFieldController.text != "") {
      return true;
    }

    return false;
  }

  void login() async {
    var response = await http.post(
      Network.api + "/login/",
      headers: Network.shared.headers(),
      body: jsonEncode(<String, String>{
        'email': _mailTextFieldController.text,
        'password': _passwordTextFieldController.text
      }),
    );

    var responseJson = json.decode(response.body);
    if (responseJson['code'] == 0) {

      Storage.shared.setItem("token", responseJson['token'].toString());
      Storage.shared.setItem("user_data", json.encode(responseJson['user']));

      Navigator
          .of(context)
          .pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => OrdersPage()));
    } else {
      showDialog(context: context, builder: (_) =>
          CustomAlertDialog.shared.dialog("Ошибка!",
              responseJson['error'].toString(),
              true,
              context, () {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return loginForm();
            },
          )
        )
    );
  }

  Widget loginForm() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            height: 120,
            width: double.infinity,
            child: Image.asset('assets/images/Zelo.png'),
          ),

          Container(
              height: 70,
              margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width * 0.1), right: (MediaQuery.of(context).size.width * 0.1), top: 50),
              decoration: BoxDecoration (
                border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[300])),
              ),

              child: Row (
                children: <Widget>[
                  Container (
                      width: 60,
                      height: 70,
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Image.asset('assets/images/mail.png')
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: TextFormField(
                        controller: _mailTextFieldController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Электронная почта',
                            hintStyle: GoogleFonts.openSans(
                                color: Colors.grey[500]
                            )
                        ),
                        style: GoogleFonts.openSans(
                            fontSize: 18
                        ),
                      ),
                    ),
                  )

                ],
              )
          ),

          Container(
              height: 70,
              margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width * 0.1), right: (MediaQuery.of(context).size.width * 0.1), top: 10),
              decoration: BoxDecoration (
                border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[300])),
              ),

              child: Row (
                children: <Widget>[
                  Container (
                      width: 60,
                      height: 70,
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Image.asset('assets/images/password.png')
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: TextFormField(
                        controller: _passwordTextFieldController,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Пароль',
                            hintStyle: GoogleFonts.openSans(
                                color: Colors.grey[500]
                            )
                        ),
                        style: GoogleFonts.openSans(
                            fontSize: 18
                        ),
                      ),
                    ),
                  )

                ],
              )
          ),

          Container(
            height: 50,
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),]
            ),

            child: FlatButton(
              color: (_fieldsFilledCorrectly()) ? Colors.blue[400] : Colors.grey,
              textColor: Colors.white,
              splashColor: (_fieldsFilledCorrectly()) ? Colors.blue[700] : Colors.grey[0],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)
              ),

              child: Text(
                  'Вход',
                  style: GoogleFonts.openSans(
                      fontSize: 22,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold
                  )
              ),
              onPressed: () {
                login();
              },
            ),
          ),

        ],
      ),
    );
  }
}