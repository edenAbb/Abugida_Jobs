
import '../helper/header.dart';

class AccountApi{
  static Future<String> login() async {
    return '${await RequestHeader.getIp()}auth/login';
  }
  static Future<String> register() async {
    return '${await RequestHeader.getIp()}auth/register';
  }
  static Future<String> forgetPassword() async {
    return '${await RequestHeader.getIp()}auth/resetAccount';
  }
  static Future<String> resetPassword(String id) async {
    return '${await RequestHeader.getIp()}users/resetPassword/$id';
  }
  static Future<String> updateAccount(String id) async {
    return '${await RequestHeader.getIp()}auth/updateAccount/$id';
  }
  static Future<String> changePassword(String id) async {
    return '${await RequestHeader.getIp()}auth/changePassword/$id';
  }
  static Future<String> checkPhoneAndStatus() async {
    return '${await RequestHeader.getIp()}users/findUserByPhoneAndStatus/';
  }
  static Future<String> checkPhone(String phone) async {
    return '${await RequestHeader.getIp()}users/findUserByPhone/$phone';
  }
  static Future<String> checkPhoneAndEmail(String phone, String email) async {
    return '${await RequestHeader.getIp()}users/findUserByPhoneAndEmail/$phone/$email';
  }
  static Future<String> uploadProfileImage(String id) async {
    return '${await RequestHeader.getIp()}users/uploadProfileImage/$id';
  }

  static Future<String> logout() async {
    return '${await RequestHeader.getIp()}auth/logout';
  }

}