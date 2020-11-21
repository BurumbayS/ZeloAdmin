
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog {
  static CustomAlertDialog shared = new CustomAlertDialog();

  String title = "";
  String text = "";
  BuildContext context;

  Widget dialog(String title, String text, bool isInfo, BuildContext context, VoidCallback onSuccess) {
    this.title = title;
    this.text = text;
    this.context = context;

    if (isInfo) {
      return (Platform.isIOS) ? _iosInfoAlertDialog(onSuccess) : _androidInfoAlertDialog(onSuccess);
    }
    return (Platform.isIOS) ? _iosAlertDialog(onSuccess) : _androidAlertDialog(onSuccess);
  }

  Widget _iosAlertDialog(VoidCallback completion) {
    return CupertinoAlertDialog(
      title: Text(
          title,
          style: GoogleFonts.capriola(
              fontSize: 18
          )
      ),
      content: Text(
          text,
          style: GoogleFonts.capriola(
              fontSize: 15
          )
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
                'Нет',
                style: GoogleFonts.capriola(
                    fontSize: 15
                )
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }
        ),
        CupertinoDialogAction(
            child: Text(
                'Да',
                style: GoogleFonts.capriola(
                    fontSize: 15
                )
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              completion();
            }
        )
      ],
    );
  }

  Widget _iosInfoAlertDialog(VoidCallback completion) {
    return CupertinoAlertDialog(
      title: Text(
          title,
          style: GoogleFonts.capriola(
              fontSize: 18
          )
      ),
      content: Text(
          text,
          style: GoogleFonts.capriola(
              fontSize: 15
          )
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
                'Ок',
                style: GoogleFonts.capriola(
                    fontSize: 15
                )
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              completion();
            }
        ),
      ],
    );
  }

  Widget _androidAlertDialog(VoidCallback completion) {
    return AlertDialog(
      title: Text(
          title,
          style: GoogleFonts.capriola(
              fontSize: 18
          )
      ),
      content: Text(
          text,
          style: GoogleFonts.capriola(
              fontSize: 15
          )
      ),
      actions: <Widget>[
        FlatButton(
            child: Text(
                'Нет'
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }
        ),
        FlatButton(
            child: Text(
                'Да'
            ),
            onPressed: () {
              completion();
              Navigator.of(context, rootNavigator: true).pop();
            }
        )
      ],
    );
  }

  Widget _androidInfoAlertDialog(VoidCallback completion) {
    return AlertDialog(
      title: Text(
          title,
          style: GoogleFonts.capriola(
              fontSize: 18
          )
      ),
      content: Text(
          text,
          style: GoogleFonts.capriola(
              fontSize: 15
          )
      ),
      actions: <Widget>[
        FlatButton(
            child: Text(
                'Нет'
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }
        ),
        FlatButton(
            child: Text(
                'Да'
            ),
            onPressed: () {
              completion();
              Navigator.of(context, rootNavigator: true).pop();
            }
        )
      ],
    );
  }
}