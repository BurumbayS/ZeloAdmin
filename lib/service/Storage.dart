import 'package:localstorage/localstorage.dart';

class Storage {
  static LocalStorage shared = new LocalStorage('business_app_data');

  static Future<String> itemBy(String key) async {
    await shared.ready;
    return shared.getItem(key);
  }
}