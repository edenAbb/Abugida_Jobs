import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';

import '../../models/user.dart';

class UserState{}
class UserInit extends UserState{}

class LoadingUser extends UserState{}
class UserLoaded extends UserState{
  final Users users;
  UserLoaded({required this.users});
}
class UserLoadingFailed extends UserState{
  final String error;
  UserLoadingFailed({required this.error});
}

class UpdatingUser extends UserState{}
class UserUpdatedSuccessfully extends UserState{}
class UserUpdatingFailed extends UserState{
  final String error;
  UserUpdatingFailed({required this.error});
}

class RemovingUser extends UserState{}
class UserRemovedSuccessfully extends UserState{}
class RemovingUserFailed extends UserState{
  final String error;
  RemovingUserFailed({required this.error});
}
