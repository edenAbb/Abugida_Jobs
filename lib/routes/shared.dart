import 'package:et_job/models/job.dart';
import 'package:et_job/models/user.dart';

import '../models/notification.dart';

class HomeScreenArgs {
  UserRole userRole;
  HomeScreenArgs({required this.userRole});
}

class ChangePasswordArgs {
  bool isOnline;

  ChangePasswordArgs({required this.isOnline});
}

class ConfirmCodeArgs {
  bool isSelected = false;
  String phone;
  String? encodedPts;
  ConfirmCodeArgs({required this.phone});
}

class ForgetPasswordArgs {
  bool isSelected = false;
  bool isOnline;
  String? encodedPts;

  ForgetPasswordArgs({required this.isOnline});
}

class LoginScreenArgs {
  bool isSelected = false;
  bool isOnline;
  String? encodedPts;

  LoginScreenArgs({required this.isOnline});
}

class RegisterScreenArgs {
  bool isSelected = false;
  bool isOnline;
  String? encodedPts;

  RegisterScreenArgs({required this.isOnline});
}
class WithdrawScreenArgs {
  String amount;
  WithdrawScreenArgs({required this.amount});
}

class ResetPasswordArgs {
  bool isSelected = false;
  String phone;
  String? encodedPts;

  ResetPasswordArgs({required this.phone});
}

class UpdateAccountArgs {
  bool isSelected = false;
  bool isOnline;
  String? encodedPts;

  UpdateAccountArgs({required this.isOnline});
}

class NtfsDetailArgs {
  JNotification notification;
  NtfsDetailArgs({required this.notification});
}
class ApplyArgs {
  Vacancy vacancy;
  UserRole role;
  ApplyArgs({required this.vacancy, required this.role});
}
class UpdateVacancyArgs {
  Vacancy vacancy;
  UpdateVacancyArgs({required this.vacancy});
}

class ViewCVArgs {
  String path;
  ViewCVArgs({required this.path});
}


