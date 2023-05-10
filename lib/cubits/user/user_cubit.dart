
import 'package:et_job/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/users.dart';
import 'user_state.dart';


class UserCubit extends Cubit<UserState>{
  UserRepository userRepository;
  UserCubit({required this.userRepository})  : super(UserInit());
  Future<void> loadUser(DataTar dataTar) async {
    emit(LoadingUser());
    try{
      var users = await userRepository.loadUsers(dataTar);
      emit(UserLoaded(users: users));
    }catch(e){
      emit(UserLoadingFailed(error: e.toString()));
    }
  }

  Future<void> updateUser(String userId) async {
    emit(UpdatingUser());
    try{
      await userRepository.updateUser(userId);
      emit(UserUpdatedSuccessfully());
    }catch(e){
      emit(UserUpdatingFailed(error: e.toString()));
    }
  }
}