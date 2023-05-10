import 'dart:convert';

import 'package:et_job/mock/wallet.dart';
import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';
import 'package:et_job/models/report.dart';
import 'package:et_job/models/transaction.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/data.dart';
import '../models/user.dart';
import '../services/api/system.dart';
import '../services/api/wallet.dart';
import '../services/helper/header.dart';
import '../utils/env/session.dart';
import 'account.dart';
class WalletRepository {
  final http.Client httpClient;
  AccountRepository authDataProvider = AccountRepository(httpClient: http.Client());
  final secureStorage = const FlutterSecureStorage();
  WalletRepository({required this.httpClient});

  Future<String> balance() async{
    final response = await http.post(
      Uri.parse(await WalletApi.loadBalance()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId()
      }),
    );
    Session().logSession('url', await WalletApi.loadBalance());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      return output['balance'];
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }

  Future<Transactions> history(DataTar dataTar) async{
    final response = await http.post(
      Uri.parse(await WalletApi.loadWalletHistory()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId()
      }),
    );
    Session().logSession('url', await WalletApi.loadWalletHistory());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        List data = output['data'];
        return Transactions.fromJson(data);
      }else{
        List<Transaction> transactions = [];
        return Transactions.fromTransactions(transactions);
      }
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }


  Future<Result> recharge(String amount) async{
    final response = await http.post(
      Uri.parse(await WalletApi.rechargeWallet()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId(),
        'amount': amount
      }),
    );
    Session().logSession('url', await WalletApi.rechargeWallet());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(), "recharge Successful");
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult().requestResult(response.statusCode.toString(), response.body);
    }
  }
  Future<Result> withdraw(String amount) async{
    final response = await http.post(
      Uri.parse(await WalletApi.withdraw()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId(),
        'amount': amount
      }),
    );
    Session().logSession('url', await WalletApi.withdraw());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return RequestResult().requestResult(response.statusCode.toString(), "Withdraw Successful");
      }else{
        return RequestResult().requestResult(response.statusCode.toString(), output['message']);
      }
    } else {
      return RequestResult().requestResult(response.statusCode.toString(), response.body);
    }
  }
  Future<Report> reports(String amount) async{
    final response = await http.post(
      Uri.parse(await WalletApi.withdraw()),
      headers: await RequestHeader().authorisedHeader(),
      body: json.encode({
        'userId':await authDataProvider.getId(),
        'amount': amount
      }),
    );
    Session().logSession('url', await WalletApi.withdraw());
    Session().logSession('url', response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = jsonDecode(response.body);
      if(output['code'] == "200"){
        return Report.fromJson(output);
      }else{
        throw 'Unable to load: ${output['message']}';
      }
    } else {
      throw 'Unable to load: ${response.statusCode}';
    }
  }



  //for testing
  Future<String> sBalance() async{
    return SWallets().getWalletBalance().message;
  }
  Future<Transactions> sHistory(DataTar dataTar) async{
    return SWallets().getWalletHistory();
  }
  Future<Result> sRecharge(String amount) async{
    return SWallets().rechargeWallet();
  }
  Future<Result> sWithdraw(String amount) async{
    return SWallets().withdraw();
  }
  Future<Report> sReports(String amount) async{
    return SWallets().sampleReport();
  }

}
