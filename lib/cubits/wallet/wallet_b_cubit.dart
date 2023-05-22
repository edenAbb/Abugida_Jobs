
import 'package:et_job/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/wallet.dart';
import 'wallet_state.dart';
class WalletBCubit extends Cubit<WalletBState>{
  WalletRepository walletRepository;
  WalletBCubit({required this.walletRepository})  : super(WalletBInit());
  Future<void> loadWalletBalance() async {
    emit(LoadingWalletBalance());
    try{
      //var transactions = await walletRepository.history(dataTar);
      var balance = await walletRepository.sBalance();
      emit(WalletBalanceLoaded(balance: balance));
    }catch(e){
      emit(WalletBalanceLoadingFailed(error: e.toString()));
    }
  }
}