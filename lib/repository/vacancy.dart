import 'dart:convert';

import 'package:et_job/mock/vacancies.dart';
import 'package:et_job/models/data.dart';
import 'package:et_job/models/job.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../services/api/vacancies.dart';
import '../services/helper/header.dart';
import '../utils/env/session.dart';
import 'account.dart';
class VacancyRepository {
  final http.Client httpClient;
  final secureStorage = const FlutterSecureStorage();
  AccountRepository authDataProvider = AccountRepository(httpClient: http.Client());
  VacancyRepository({required this.httpClient});

  Future<Vacancies> fakeVacancies(DataTar dataTar) async{
    return SVacancies().getVacancies();
  }
  Future<Vacancies> fakeSearch(DataTar dataTar, String query) async{
    return SVacancies().searchVacancies(query);
  }

  Future<Vacancies> myFakeVacancies(DataTar dataTar) async{
    return SVacancies().getVacancies();
  }
  Future<Vacancies> loadVacancies(DataTar dataTar) async{
    final response = await http.get(
      Uri.parse(await VacancyApi.loadVacancies()),
      headers: await RequestHeader().authorisedHeader(),
      // body: json.encode({
      //   'userId':await authDataProvider.getId()
      // }),
    );
    Session().logSession('url -> ',await VacancyApi.loadVacancies());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        List data = output['data'];
        return Vacancies.fromJson(data);
      }else{
        List<Vacancy> vacancies = [];
        return Vacancies.fromVacancy(vacancies);
      }
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }
  Future<Vacancies> loadMyVacancies(DataTar dataTar) async{
    final response = await http.get(
        Uri.parse(await VacancyApi
            .loadMyVacancies(await authDataProvider.getId()??"0")),
        headers: await RequestHeader().authorisedHeader()
    );
    Session().logSession('url -> ',await VacancyApi.loadMyVacancies(await authDataProvider.getId() ?? "0"));
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        List data = output['data'];
        return Vacancies.fromJson(data);
      }else{
        List<Vacancy> vacancies = [];
        return Vacancies.fromVacancy(vacancies);
      }
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }
  Future<Vacancies> searchVacancies(DataTar dataTar, String category, String query) async{
    final response = await http.get(
        Uri.parse(await VacancyApi.searchVacancies(category,query)),
        headers: await RequestHeader().authorisedHeader()
    );
    Session().logSession('url -> ',await VacancyApi.searchVacancies(category,query));
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        List data = output['data'];
        return Vacancies.fromJson(data);
      }else{
        List<Vacancy> vacancies = [];
        return Vacancies.fromVacancy(vacancies);
      }
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }

  Future<Result> publishVacancy(Vacancy vacancy) async{
    final response = await http.post(
      Uri.parse(await VacancyApi.createVacancy()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
            'title': vacancy.jobTitle,
            'description': vacancy.jobDescription,
            'type': jTypeFromType(vacancy.jobType),
            'environment': jEnvFromEnv(vacancy.jobEnvironment),
            'location': vacancy.jobLocation,
            'qualification': jQuaFromQua(vacancy.qualification),
            'experience': vacancy.experience,
            'end_date': vacancy.endDate,
            'status': vacancy.jobStatus,
            'category': jCatFromCat(vacancy.jobCategory),
            'owner': await authDataProvider.getId(),
      }),
    );
    Session().logSession('url -> ',await VacancyApi.createVacancy());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }
  String getStatus(Vacancy vacancy,int target){
    var newVacancy = vacancy;
    String status = vacancy.jobStatus;
    switch(target){
      case 1:
        status = "open";
        break;
      case 2:
        status = "closed";
        break;
      case 3:
        status = "ongoing";
        break;
      case 4:
        status = "complete";
        break;
      case 5:
        status = "archive";
        break;
    }
    //newVacancy.jobStatus = status;
    return status;
  }
  Future<Result> updateVacancy(Vacancy vacancy, int target) async{
    //Vacancy vacancy = getStatus(oldVacancy, target);
    final response = await http.post(
      Uri.parse(await VacancyApi.updateVacancy()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'id': vacancy.jobId,
        'title': vacancy.jobTitle,
        'description': vacancy.jobDescription,
        'type': jTypeFromType(vacancy.jobType),
        'environment': jEnvFromEnv(vacancy.jobEnvironment),
        'location': vacancy.jobLocation,
        'qualification': jQuaFromQua(vacancy.qualification),
        'experience': vacancy.experience,
        'endDate': vacancy.endDate,
        'status': getStatus(vacancy, target),
        'category': jCatFromCat(vacancy.jobCategory),
        'owner': await authDataProvider.getId(),
      }),
    );
    Session().logSession('url -> ',await VacancyApi.updateVacancy());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(),output['message']);
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }

  Future<Result> applyForJob(Vacancy vacancy) async{
    final response = await http.post(
      Uri.parse(await VacancyApi.applyForJob()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'vacId': vacancy.jobId,
        'userId':await authDataProvider.getId(),
        'ownerId': vacancy.user?.id ?? "",
        'vacStatus': vacancy.jobStatus,
        'ntfs': 1,
        'ntfsTitle': "raw title",
        'ntfsBBody': "raw body"
      }),
    );
    Session().logSession('url -> ',await VacancyApi.applyForJob());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(),output['message']);
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }
  Future<Result> acceptRequest(Vacancy vacancy) async{
    final response = await http.post(
      Uri.parse(await VacancyApi.acceptRequest()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'vacId': vacancy.jobId,
        'userId':await authDataProvider.getId(),
        'ownerId': vacancy.user?.id ?? "",
        'vacStatus': vacancy.jobStatus,
        'ntfs': 1,
        'ntfsTitle': "raw title",
        'ntfsBBody': "raw body"
      }),
    );
    Session().logSession('url -> ',await VacancyApi.acceptRequest());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(),output['message']);
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }
  Future<Result> cancelProgress(Vacancy vacancy) async{
    final response = await http.post(
      Uri.parse(await VacancyApi.cancelProgress()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'vacId': vacancy.jobId,
        'userId': await authDataProvider.getId(),
        'ownerId': vacancy.user?.id ?? "",
        'vacStatus': vacancy.jobStatus,
        'ntfs': 1,
        'ntfsTitle': "raw title",
        'ntfsBBody': "raw body"
      }),
    );
    Session().logSession('url -> ',await VacancyApi.cancelProgress());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(),output['message']);
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }
  Future<Result> completeJob(Vacancy vacancy) async{
    final response = await http.post(
      Uri.parse(await VacancyApi.completeJob()),
      headers: await RequestHeader().defaultHeader(),
      body: json.encode({
        'vacId': vacancy.jobId,
        'userId':await authDataProvider.getId(),
        'ownerId': vacancy.user?.id ?? "",
        'vacStatus': vacancy.jobStatus,
        'ntfs': 1,
        'ntfsTitle': "raw title",
        'ntfsBBody': "raw body"
      }),
    );
    Session().logSession('url -> ',await VacancyApi.completeJob());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(),output['message']);
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }



  Future<Result> removeVacancy(Vacancy vacancy) async{
    final response = await http.post(
      Uri.parse(await VacancyApi.deleteVacancy()),
      headers: await RequestHeader().defaultHeader());
    Session().logSession('url -> ',await VacancyApi.deleteVacancy());
    Session().logSession('url -> ',response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(), "Login Successful");
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      throw 'Unable to process your request';
      return RequestResult().requestResult(response.statusCode.toString(),
          "Unable to process your request");
    }
  }

}
