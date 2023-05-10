import 'dart:convert';

import 'package:et_job/mock/users.dart';
import 'package:et_job/models/data.dart';
import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';
import 'package:et_job/services/api/users.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../services/helper/header.dart';
import '../utils/env/session.dart';
class UserRepository {
  final http.Client httpClient;
  final secureStorage = const FlutterSecureStorage();
  UserRepository({required this.httpClient});


  Future<Users> fakeUsers(DataTar dataTar) async{
    return SUsers().getUsers();
  }

  Future<Users> loadUsers(DataTar dataTar) async{
    final response = await http.get(
      Uri.parse(await UsersApi.getUsers()),
      headers: await RequestHeader().authorisedHeader(),
      // body: json.encode({
      //   'userId':await authDataProvider.getId()
      // }),
    );
    Session().logSession('url',await UsersApi.getUsers());
    Session().logSession('url',response.body.toString());
    if (response.statusCode == 200) {
      List output = jsonDecode(response.body)['data'];
      return Users.fromJson(output);
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }

  Future<Result> updateUser(String id) async{
    final response = await http.post(
      Uri.parse('/auth/update'),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({'id': id}),
    );
    Session().logSession('url',response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(), "Login Successful");
      } else {
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult().requestResult(response.statusCode.toString(), response.body);
    }
  }

}
