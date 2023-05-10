
import '../helper/header.dart';

class ConfigApi{
  static String createVacancy(){
    return '${RequestHeader.getIp()}auth/login';
  }
  static String loadVacancies(){
    return '${RequestHeader.getIp()}auth/register';
  }
  static String updateVacancy(){
    return '${RequestHeader.getIp()}uth/resetAccount';
  }
  static String getAppliedUsers(){
    return '${RequestHeader.getIp()}auth/resetAccount';
  }
  static String getUserProfile(String id){
    return '${RequestHeader.getIp()}auth/updateAccount/$id';
  }
  static String deleteVacancy(String id){
    return '${RequestHeader.getIp()}auth/changePassword/$id';
  }
}