import 'package:et_job/models/report.dart';
import 'package:et_job/models/transaction.dart';
import 'package:et_job/models/user.dart';
import 'package:et_job/services/helper/header.dart';

class SWallets{
  Result rechargeWallet(){
    return Result("200", true, "Wallet Recharged", UserRole.guest);
  }
  Result getWalletBalance(){
    return Result("200", true, "Wallet Recharged", UserRole.guest);
  }
  Result withdraw(){
    return Result("200", true, "Wallet Recharged", UserRole.guest);
  }

  Transactions getWalletHistory(){
    List<Transaction> transactions = [];
    for(int x = 0; x < 20; x++){
      transactions.add(sampleTransaction(x));
    }
    return Transactions.fromTransactions(transactions);
  }
  Transaction sampleTransaction(int x){
    return Transaction(id: x.toString(),
        title: x % 2 == 0 ? "Received" : "Sent", body: "You received 3000.ETB from F-Tech",
        date: "today", status: 2, type: 1);
  }

  Report sampleReport(){
    var vacancyReport = VacancyReport(title: "Vacancies",
        open: "124", close: "3",
        ongoing: "45", completed: "98"
        , archived: "35");
    var userReport = UserReport(title: "Users",
        employee: "432", employer: "123", admin: "25");
    var transactionReport = TransactionReport(title: "Transactions",
        total: "87.345",
        paid: "67.345",
        fee: "20.000");
    Report report = Report(id: "67",
        title: "Reports",
        vacancyReport: vacancyReport,
        userReport: userReport,
        transactionReport: transactionReport,
        type: 1);
    return report;
  }
}