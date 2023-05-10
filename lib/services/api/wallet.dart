
import '../helper/header.dart';

class WalletApi{
  static Future<String> loadBalance() async {
    return '${await RequestHeader.getIp()}auth/wallet/balance';
  }
  static Future<String> loadWalletHistory() async {
    return '${await RequestHeader.getIp()}auth/wallet/history';
  }
  static Future<String> rechargeWallet() async {
    return '${await RequestHeader.getIp()}uth/wallet/recharge';
  }
  static Future<String> withdraw() async {
    return '${await RequestHeader.getIp()}auth/wallet/withdraw';
  }
  static Future<String> reports() async {
    return '${await RequestHeader.getIp()}auth/reports';
  }

}