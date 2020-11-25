import 'dart:convert';

import 'package:ZeloBusiness/models/Order.dart';
import 'package:ZeloBusiness/service/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import 'Network.dart';

typedef OrderCallback = Function(Order order);

class PushNotificationPlugin {
  PushNotificationPlugin(OrderCallback onReceiveHandler) {
    init(onReceiveHandler);
  }

  void init(OrderCallback onReceiveHandler) async {

    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    OneSignal.shared.init(
        "5573dacb-c34f-40f9-a46d-cc427ec3f23c",
        iOSSettings: {
          OSiOSSettings.autoPrompt: true,
          OSiOSSettings.inAppLaunchUrl: false
        }
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setSubscriptionObserver((changes) async {
      var jsonString = changes.jsonRepresentation().replaceAll(RegExp('\n'), '').replaceAll(RegExp('\"{'), '{').replaceAll(RegExp('}\"'), '}');
      var json = jsonDecode(jsonString);

      var token = json['to']['pushToken'];
      var userID = json['to']['userId'];
      if(token != null && userID != null) {
        registerPushToken(token, userID);
      }
    });

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      var orderJson = jsonDecode(notification.payload.additionalData['order']);
      Order order = Order.fromJson(orderJson);
      onReceiveHandler(order);
    });
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  void registerPushToken(token, userID) async {
    print(Network.shared.headers());
    print(jsonEncode(<String, String>{
      'push_token': token,
      'user_id': userID
    }));
    var response = await http.post(
      Network.api + "/push_token/",
      headers: Network.shared.headers(),
      body: jsonEncode(<String, String>{
        'push_token': token,
        'user_id': userID
      }),
    );

    var json = jsonDecode(response.body);
    print(json);
  }

}