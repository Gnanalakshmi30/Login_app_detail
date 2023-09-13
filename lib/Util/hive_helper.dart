import 'package:hive/hive.dart';

class HiveHelper {
  static final HiveHelper _singleton = new HiveHelper._internal();
  factory HiveHelper() {
    return _singleton;
  }
  HiveHelper._internal();

  void saveLoginStatus(bool success) async {
    var box = Hive.box('appData');
    box.put('login', success);
  }

  bool getLoginStatus() {
    var box = Hive.box('appData');
    bool? success = box.get('login');
    if (success != null) {
      return success;
    } else {
      return false;
    }
  }

  void saveCurrentIP(String ip) async {
    var box = Hive.box('appData');
    box.put('ipData', ip);
  }

  String getCurrentIP() {
    var box = Hive.box('appData');
    String? ip = box.get('ipData');
    if (ip != null) {
      return ip;
    } else {
      return "";
    }
  }

  void saveCurrentLocation(String location) async {
    var box = Hive.box('appData');
    box.put('locationData', location);
  }

  String getCurrentLocation() {
    var box = Hive.box('appData');
    String? location = box.get('locationData');
    if (location != null) {
      return location;
    } else {
      return "";
    }
  }

  void saveCurrentPostalCode(String postalCode) async {
    var box = Hive.box('appData');
    box.put('postalCode', postalCode);
  }

  String getCurrentPostalCode() {
    var box = Hive.box('appData');
    String? postalCode = box.get('postalCode');
    if (postalCode != null) {
      return postalCode;
    } else {
      return "";
    }
  }
}
