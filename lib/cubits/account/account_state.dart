import '../../models/user.dart';

class AccountState{}
class AccountInit extends AccountState{}
class LoginOnProcess extends AccountState{}
class LoginSuccessfully extends AccountState{}
class LoginFailed extends AccountState{
  final String error;
  LoginFailed({required this.error});
}

class UpdateOnProcess extends AccountState{}
class UpdatedSuccessfully extends AccountState{
  final String message;
  UpdatedSuccessfully({required this.message});
}
class UpdatingFailed extends AccountState{
  final String error;
  UpdatingFailed({required this.error});
}

class LogoutOnProcess extends AccountState{}
class LogoutSuccessfully extends AccountState{}
class LogoutFailed extends AccountState{
  final String error;
  LogoutFailed({required this.error});
}

class LoadOnProcess extends AccountState{}
class LoadedSuccessfully extends AccountState{
  final User user;
  LoadedSuccessfully({required this.user});
}
class LoadFailed extends AccountState{
  final String error;
  LoadFailed({required this.error});
}
