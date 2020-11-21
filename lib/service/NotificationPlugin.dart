//import 'dart:io';
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//class NotificationPlugin {
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//  NotificationPlugin() {
//    init();
//  }
//
//  init() async {
//    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//    if (Platform.isIOS) {
//      _requestIOSPermission();
//    }
//
//    initializePlatformSpecifics();
//  }
//
//  initializePlatformSpecifics() {
//    var initializationSettingsAndroid =
//    AndroidInitializationSettings('@mipmap/ic_launcher');
//    var initializationSettingsIOS = IOSInitializationSettings();
//    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//    flutterLocalNotificationsPlugin.initialize(initSettings,
//        onSelectNotification: onSelectNotification);
//  }
//
//  Future onSelectNotification(String payload) {
////    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
////      return NewScreen(
////        payload: payload,
////      );
////    }));
//  }
//
//  _requestIOSPermission() {
//    flutterLocalNotificationsPlugin
//        .resolvePlatformSpecificImplementation<
//        IOSFlutterLocalNotificationsPlugin>()
//        .requestPermissions(
//      alert: false,
//      badge: true,
//      sound: true,
//    );
//  }
//
//}
//
//class ReceivedNotification {
//  final int id;
//  final String title;
//  final String body;
//  final String payload;
//
//  ReceivedNotification({
//    @required this.id,
//    @required this.title,
//    @required this.body,
//    @required this.payload
//  });
//}