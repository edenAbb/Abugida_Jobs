import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';
import 'package:et_job/models/transaction.dart';

import '../../models/report.dart';
import '../../models/user.dart';

class WalletState{}
class WalletInit extends WalletState{}

class WalletBState{}
class WalletBInit extends WalletBState{}

class LoadingWalletBalance extends WalletBState{}
class WalletBalanceLoaded extends WalletBState{
  final String balance;
  WalletBalanceLoaded({required this.balance});
}
class WalletBalanceLoadingFailed extends WalletBState{
  final String error;
  WalletBalanceLoadingFailed({required this.error});
}



class LoadingWalletHistory extends WalletState{}
class WalletHistoryLoaded extends WalletState{
  final Transactions transactions;
  WalletHistoryLoaded({required this.transactions});
}
class WalletHistoryLoadingFailed extends WalletState{
  final String error;
  WalletHistoryLoadingFailed({required this.error});
}



class RechargingWallet extends WalletState{}
class WalletRechargedSuccessfully extends WalletState{}
class WalletRechargingFailed extends WalletState{
  final String error;
  WalletRechargingFailed({required this.error});
}

class WithdrawMoney extends WalletState{}
class MoneyWithdrawSuccessfully extends WalletState{}
class MoneyWithdrawFailed extends WalletState{
  final String error;
  MoneyWithdrawFailed({required this.error});
}

class LoadingReports extends WalletState{}
class ReportLoadedSuccessfully extends WalletState{
  final Report report;
  ReportLoadedSuccessfully({
    required this.report
  });
}
class LoadReportFailed extends WalletState{
  final String error;
  LoadReportFailed({required this.error});
}
