import 'dart:convert';

import 'package:et_job/mock/users.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../services/api/account.dart';
import '../services/helper/header.dart';
import '../utils/env/session.dart';

class AccountRepository {
  final http.Client httpClient;
  final secureStorage = const FlutterSecureStorage();
  AccountRepository({required this.httpClient});

  Future<Result> fakeLogin(String userName) async {
    final Map<String, dynamic> _user = {};
    _user['id'] = "0";
    _user['fullname'] = "Tester";
    _user['phone'] = "0900112233";
    _user['email'] = "user@test.edu";
    _user['email'] = "user@test.edu0099000";
    _user['gender'] = "male";
    var result = SUsers().login(userName);
    switch(result.userRole){
      case UserRole.admin:
        _user['role'] = "admin";
        break;
      case UserRole.employer:
        _user['role'] = "employer";
        break;
      case UserRole.employee:
        _user['role'] = "employee";
        break;
      case UserRole.moderator:
        _user['role'] = "moderator";
        break;
      case UserRole.guest:
        _user['role'] = "guest";
        break;
    }
    if(result.success){
      setUserToLocal(_user);
    }
    return result;
  }

  Future<Result> setUserToLocal(Map<String, dynamic> user) async {
    await secureStorage.write(
        key: 'id', value: user.containsKey('id') ? user['id'].toString() : '0');
    await secureStorage.write(key: 'phone', value: user['phone']);
    await secureStorage.write(key: 'full_name', value: user['fullname']);
    await secureStorage.write(
        key: 'token', value: user.containsKey('token') ? user['token'] : '');
    await secureStorage.write(
        key: "email", value: user.containsKey('email') ? user['email'] : '');
    String iPath = user.containsKey('photo')
        ? user['photo'] : "";
    await secureStorage.write(key: 'profile_image', value: await RequestHeader.getIp() + iPath);
    await secureStorage.write(key: "gender", value: user['gender'] ?? "");
    await secureStorage.write(key: "role", value: user['role'] ?? "");
    await secureStorage.write(key: "wallet", value: user['wallet'] ?? "0");

    await secureStorage.write(key: "education", value: user['education'] ?? "Unavailable");
    await secureStorage.write(key: "environment", value: user['environment'] ?? "Unavailable");
    await secureStorage.write(key: "category", value: user['category'] ?? "Unavailable");
    await secureStorage.write(key: "job_type", value: user['job_type'] ?? "Unavailable");
    await secureStorage.write(key: "experience", value: user['experience'] ?? "0");
    return Result("200", true, "message",getRole(user['role'] ?? ""));
  }

  Future<Result> fakeRegister(Map<String, dynamic> user) async {
    return setUserToLocal(user);
  }

  Future<Result> loginUser(Map<String, dynamic> user) async {
    Session().logSession('url', await AccountApi.login());
    final response = await http.post(
      Uri.parse(await AccountApi.login()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'phone': user["phone"],
        'password': user['password'],
      }),
    );
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if (output['code'] == "200") {
        // Session().logSession('url',output.toString());
        setUserToLocal(output);
        return Result(response.statusCode.toString(),true,
            "Login Successful",getRole(output['role'] ?? 'guest'));
      } else {
        return RequestResult()
            .requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(),
          jsonDecode(response.body)['error']);
    }
  }

  Future<Result> startRegistration(Map<String, dynamic> user) async {
    Session().logSession('url', await AccountApi.register());
    final response = await http.post(
      Uri.parse(await AccountApi.register()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'fullname': user["full_name"],
        'phone': user["phone"],
        'email': user["email"],
        'gender': user["gender"],
        'role': user["role"],
        'password': user['password']
      }),
    );
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output;
      try{
        output = jsonDecode(response.body);
        if (output['code'] == "200") {
          Session().logSession('url',output.toString());
          setUserToLocal(output);
          return Result(response.statusCode.toString(),true, "Registration Successful",getRole(output['role'] ?? 'guest'));
        } else {
          return RequestResult()
              .requestResult(response.statusCode.toString(), output['message']);
        }
      }catch(e){
        return RequestResult()
            .requestResult(response.statusCode.toString(),
            "Unable to parse response");
      }

    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }

  Future<Result> registerUser(Map<String, dynamic> user) async {
    return isPhoneRegistered(user["phone"]).then((value) {
      if (!value.success) {
        //Session().logSession('phone-check',value.message.toString())
        return startRegistration(user);
      } else {
        Session().logSession('phone-check', value.message.toString());
        throw 'phone already registered';
      }
    }).onError((error, stackTrace) => throw 'unable to check');
  }

  Future<Result> updateUser(User user) async {
    final response = await http.post(
      Uri.parse(await AccountApi.updateAccount(user.id)),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'fullname': user.fullName,
        'email': user.email,
        'education': user.education,
        'category': user.category,
        'environment': user.environment,
        'job_type': user.jobType,
        'experience': user.experience,
      }),
    );
    Session().logSession('url', await AccountApi.updateAccount(user.id));
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if (output['code'] == "200") {
        setUserToLocal(output);
        return RequestResult()
            .requestResult(response.statusCode.toString(), "Update Successful");
      } else {
        return RequestResult()
            .requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }

  Future<Result> isPhoneRegistered(String phone) async {
    final response = await http.get(
      Uri.parse(await AccountApi.checkPhone(phone)),
      headers: await RequestHeader().defaultHeader(),
    );
    Session().logSession('url', await AccountApi.checkPhone(phone));
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if (output['code'] == "200") {
        return RequestResult()
            .requestResult(response.statusCode.toString(), output['message']);
      } else {
        return RequestResult()
            .requestResult(output['code'].toString(), output['message']);
      }
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }
  Future<Result> changePassword(Map<String, dynamic> passwords) async {
    final response = await http.post(
      Uri.parse(await AccountApi.changePassword(await getPhone() ?? "")),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'old_password': passwords['old_password'],
        'new_password': passwords['new_password'],
      }),
    );
    Session().logSession('url', await AccountApi.changePassword(await getPhone() ?? ""));
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if (output['code'] == "200") {
        return RequestResult()
            .requestResult(response.statusCode.toString(), "Update Successful");
      } else {
        return RequestResult()
            .requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }
  Future<Result> resetPassword(Map<String, dynamic> passwords) async {
    final response = await http.post(
      Uri.parse(await AccountApi.resetPassword(passwords['phone'])),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'new_password': passwords['new_password'],
      }),
    );
    Session().logSession('url', await AccountApi.resetPassword(passwords['phone']));
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if (output['code'] == "200") {
        return RequestResult()
            .requestResult(response.statusCode.toString(), "Update Successful");
      } else {
        return RequestResult()
            .requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }

  Future<Result> uploadProfileImage(String photo) async {
    final response = await http.post(
      Uri.parse(await AccountApi.uploadProfileImage(await getPhone() ?? "")),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'photo': photo
      }),
    );
    Session().logSession('url', response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if (output['code'] == "200") {
        return RequestResult()
            .requestResult(response.statusCode.toString(), "Update Successful");
      } else {
        return RequestResult()
            .requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult()
          .requestResult(response.statusCode.toString(), response.body);
    }
  }


  Future<User> getUserData() async {
    final token = await secureStorage.readAll();
    return User.fromStorage(token);
  }

  Future updateUserData(String fullName, String email) async {
    await secureStorage.write(key: 'full_name', value: fullName);
    await secureStorage.write(key: "email", value: email);
  }

  Future updateProfilePic(String url) async {
    await secureStorage.write(
        key: 'profile_image', value: await RequestHeader.getIp() + "profile/" + url);
  }

  Future logOut() async {
    await secureStorage.deleteAll();
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: "token");
  }

  Future<String?> getId() async {
    return await secureStorage.read(key: "id");
  }
  Future<String?> getPhone() async {
    return await secureStorage.read(key: "phone");
  }


  Future<bool> isUserLocallyPersisted() async {
    return await secureStorage.read(key: "token") != null;
  }

  Future<String?> getImageUrl() async {
    return await secureStorage.read(key: "profile_image");
  }
}
