
import '../helper/header.dart';

class SystemApi{
  static Future<String> loadNotification() async {
    return '${await RequestHeader.getIp()}auth/login';
  }
  static Future<String> updateNotification() async {
    return '${await RequestHeader.getIp()}auth/updateNotification';
  }
}