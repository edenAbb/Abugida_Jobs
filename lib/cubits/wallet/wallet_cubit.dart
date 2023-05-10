
import 'package:et_job/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/wallet.dart';
import 'wallet_state.dart';
class WalletCubit extends Cubit<WalletState>{
  WalletRepository walletRepository;
  WalletCubit({required this.walletRepository})  : super(WalletInit());
  Future<void> loadWalletHistory(DataTar dataTar) async {
    emit(LoadingWalletHistory());
    try{
      //var transactions = await walletRepository.history(dataTar);
      var transactions = await walletRepository.sHistory(dataTar);
      emit(WalletHistoryLoaded(transactions: transactions));
    }catch(e){
      emit(WalletHistoryLoadingFailed(error: e.toString()));
    }
  }

  Future<void> rechargingWallet(String walletId) async {
    emit(RechargingWallet());
    try{
      await walletRepository.recharge(walletId);
      emit(WalletRechargedSuccessfully());
    }catch(e){
      emit(WalletRechargingFailed(error: e.toString()));
    }
  }
  Future<void> withdrawWallet(String walletId) async {
    emit(RechargingWallet());
    try{
      await walletRepository.recharge(walletId);
      emit(WalletRechargedSuccessfully());
    }catch(e){
      emit(WalletRechargingFailed(error: e.toString()));
    }
  }

  Future<void> reports(String walletId) async {
    emit(LoadingReports());
    try{
      //var reports = await walletRepository.reports(walletId);
      var reports = await walletRepository.sReports(walletId);
      emit(ReportLoadedSuccessfully(report: reports));
    }catch(e){
      emit(LoadReportFailed(error: e.toString()));
    }
  }
}