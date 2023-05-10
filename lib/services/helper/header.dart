import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../repository/account.dart';
import '../../utils/constants/network.dart';

import 'package:http/http.dart' as http;

import '../../utils/env/session.dart';

class RequestHeader {
  //static const String baseApp = "http://192.168.0.30/api/";
  static const String basePortal = "http://localhost:8000/api/";
  AccountRepository authDataProvider = AccountRepository(httpClient: http.Client());

  Future<Map<String, String>>? authorisedHeader() async => <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await authDataProvider.getToken()}'
      };

  Future<Map<String, String>>? defaultHeader() async => <String, String>{
        'Content-Type': 'application/json',
        'app-key': 'OGV8V1FCa1FXaDVGZw'
      };
  static Future<void> setIp(String ip) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("server-ip", ip);
    print(ip);
  }
  static Future<String> getIp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString("server-ip") ?? "0";
    return 'http://$ip/api/';
  }
  static Future<String> getRawIp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString("server-ip") ?? "0";
    return ip;
  }


}

class RequestResult {
  Result requestResult(String code, String body) {
    //Session().logSession("response", "code: $code, body $body");
    if (code == "200") {
      return Result(code, true, body,getRole('guest'));
    } else {
      //return Result(code, false, _prepareResult(code), UserRole.employee);
      return Result(code, false, body, UserRole.employee);
    }
  }

  String _prepareResult(code) {
    switch (code) {
      case anAuthorizedC:
        return anAuthorizedM;
      case accessForbiddenC:
        return accessForbiddenM;
      case notFoundC:
        return notFoundM;
      case serverErrorC:
        return serverErrorM;
      case requestTimeoutC:
        return requestTimeoutM;
      default:
        return unknownErrorM;
    }
  }
}

class Result {
  final String code;
  final bool success;
  final String message;
  final UserRole userRole;

  Result(this.code, this.success, this.message, this.userRole);
}
