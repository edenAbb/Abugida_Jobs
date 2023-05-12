import 'package:easy_localization/easy_localization.dart';
import 'package:et_job/cubits/account/account_state.dart';
import 'package:et_job/repository/account.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';

class AccountCubit extends Cubit<AccountState>{
  AccountRepository accountRepository;
  AccountCubit({required this.accountRepository})  : super(AccountInit());
  Future<void> login(Map<String, dynamic> user) async {
    emit(LoginOnProcess());
    try{
      await accountRepository.loginUser(user);
      emit(LoginSuccessfully());
    }catch(e){
      emit(LoginFailed(error: e.toString()));
    }
  }
  Future<void> update(User user) async {
    emit(UpdateOnProcess());
    try{
      var message = await accountRepository.updateUser(user);
      emit(UpdatedSuccessfully(message: message.message));
    }catch(e){
      emit(UpdatingFailed(error: e.toString()));
    }
  }
  Future<void> loadProfile() async {
    emit(LoadOnProcess());
    try{
      var data = await accountRepository.getUserData();
      emit(LoadedSuccessfully(user: data));
    }catch(e){
      emit(LoadFailed(error: e.toString()));
    }
  }
  Future<void> logout() async {
    emit(LogoutOnProcess());
    try{
      await accountRepository.logOut();
      emit(LogoutSuccessfully());
    }catch(e){
      emit(LogoutFailed(error: e.toString()));
    }
  }



}