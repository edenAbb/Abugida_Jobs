import 'dart:convert';

import 'package:et_job/mock/notifications.dart';
import 'package:et_job/models/data.dart';
import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../services/api/system.dart';
import '../services/helper/header.dart';
import '../utils/env/session.dart';
import 'account.dart';
class NotificationRepository {
  final http.Client httpClient;
  AccountRepository authDataProvider = AccountRepository(httpClient: http.Client());
  final secureStorage = const FlutterSecureStorage();
  NotificationRepository({required this.httpClient});

  Future<Notifications> fakeNotifications(DataTar dataTar) async{
    return SNotifications().getNotifications();
  }

  Future<Notifications> loadNotifications() async{
    final response = await http.post(
      Uri.parse(await SystemApi.loadNotification()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId()
      }),
    );
    Session().logSession('url', await SystemApi.loadNotification());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      List output = jsonDecode(response.body);
      return Notifications.fromJson(output);
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }

  Future<Result> updateNotification(String notificationId) async{
    final response = await http.post(
      Uri.parse(await SystemApi.updateNotification()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId(),
        'notificationId': notificationId,
        'status': '2'
      }),
    );
    Session().logSession('url', await SystemApi.updateNotification());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(), "Login Successful");
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult().requestResult(response.statusCode.toString(), response.body);
    }
  }

}
