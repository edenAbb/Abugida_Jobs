
import '../helper/header.dart';

class UsersApi{
  static Future<String> getUsers() async {
    return '${await RequestHeader.getIp()}auth/getUsers';
  }
  static Future<String> loadVacancies() async {
    return '${await RequestHeader.getIp()}auth/register';
  }
  static Future<String> updateVacancy() async {
    return '${await RequestHeader.getIp()}uth/resetAccount';
  }
  static Future<String> getAppliedUsers() async {
    return '${await RequestHeader.getIp()}auth/resetAccount';
  }
  static Future<String> getUserProfile(String id) async {
    return '${await RequestHeader.getIp()}auth/updateAccount/$id';
  }
  static Future<String> deleteVacancy(String id) async {
    return '${await RequestHeader.getIp()}auth/changePassword/$id';
  }
}