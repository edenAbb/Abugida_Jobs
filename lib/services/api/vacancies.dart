
import '../helper/header.dart';

class VacancyApi{
  static Future<String> loadVacancies() async {
    return '${await RequestHeader.getIp()}auth/vacancies';
  }
  static Future<String> loadMyVacancies(String id) async {
    return '${await RequestHeader.getIp()}auth/myVacancies/$id';
  }
  static Future<String> createVacancy() async {
    return '${await RequestHeader.getIp()}auth/createVacancy';
  }
  static Future<String> updateVacancy() async {
    return '${await RequestHeader.getIp()}auth/updateVacancy';
  }
  static Future<String> deleteVacancy() async {
    return '${await RequestHeader.getIp()}auth/deleteVacancy';
  }
  static Future<String> getUserProfile(String id) async {
    return '${await RequestHeader.getIp()}auth/updateAccount/$id';
  }
}