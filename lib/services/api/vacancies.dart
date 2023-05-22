
import '../helper/header.dart';

class VacancyApi{
  static Future<String> loadVacancies() async {
    return '${await RequestHeader.getIp()}auth/vacancies';
  }
  static Future<String> loadMyVacancies(String id) async {
    return '${await RequestHeader.getIp()}auth/myVacancies/$id';
  }
  static Future<String> searchVacancies(String category, String query) async {
    return '${await RequestHeader.getIp()}auth/vacancy/search/$category/$query';
  }
  static Future<String> createVacancy() async {
    return '${await RequestHeader.getIp()}auth/createVacancy';
  }
  static Future<String> updateVacancy() async {
    return '${await RequestHeader.getIp()}auth/updateVacancy';
  }

  static Future<String> applyForJob() async {
    return '${await RequestHeader.getIp()}auth/vacancy/apply';
  }
  static Future<String> acceptRequest() async {
    return '${await RequestHeader.getIp()}auth/vacancy/accept';
  }
  static Future<String> cancelProgress() async {
    return '${await RequestHeader.getIp()}auth/vacancy/cancel';
  }
  static Future<String> completeJob() async {
    return '${await RequestHeader.getIp()}auth/vacancy/complete';
  }
  static Future<String> deleteVacancy() async {
    return '${await RequestHeader.getIp()}auth/deleteVacancy';
  }
  static Future<String> getUserProfile(String id) async {
    return '${await RequestHeader.getIp()}auth/updateAccount/$id';
  }
}