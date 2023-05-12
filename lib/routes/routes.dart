import 'package:et_job/screens/home/employee/apply.dart';
import 'package:et_job/screens/home/employer/create_vacancy.dart';
import 'package:et_job/screens/notifications/view_notification.dart';
import 'package:et_job/screens/settings/setting.dart';
import 'package:et_job/screens/wallet/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../init/splash.dart';
import '../screens/account/change_password.dart';
import '../screens/account/confirm_otp.dart';
import '../screens/account/forget_password.dart';
import '../screens/account/login.dart';
import '../screens/account/register.dart';
import '../screens/account/reset_password.dart';
import '../screens/account/update_account.dart';
import '../screens/root/cubit/botttom_nav_cubit.dart';
import '../screens/root/root_screen.dart';
import '../screens/search/search.dart';
import 'shared.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == ConfirmCode.routeName) {
      ConfirmCodeArgs argument =
      settings.arguments as ConfirmCodeArgs;
      return MaterialPageRoute(
          builder: (context) => ConfirmCode(
            args: argument,
          ));
    }
    if (settings.name == HomeScreen.routeName) {
      HomeScreenArgs argument = settings.arguments as HomeScreenArgs;
      return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => BottomNavCubit(),
              child: HomeScreen(
                args: argument,
              ),
            );
          });
    }
    if (settings.name == ResetPassword.routeName) {
      ResetPasswordArgs argument = settings.arguments as ResetPasswordArgs;
      return MaterialPageRoute(builder: (context) => ResetPassword(
        args: argument,
      ));
    }
    if (settings.name == UpdateAccount.routeName) {
      UpdateAccountArgs argumnet = settings.arguments as UpdateAccountArgs;
      return MaterialPageRoute(
          builder: (context) => UpdateAccount(
            args: argumnet,
          ));
    }
    if (settings.name == ChangePassword.routeName) {
      ChangePasswordArgs argument =
      settings.arguments as ChangePasswordArgs;
      return MaterialPageRoute(
          builder: (context) => ChangePassword(
            arg: argument,
          ));
    }
    if (settings.name == ForgetPassword.routeName) {
      ForgetPasswordArgs argument =
      settings.arguments as ForgetPasswordArgs;
      return MaterialPageRoute(
          builder: (context) => ForgetPassword(
            args: argument,
          ));
    }

    if (settings.name == LoginScreen.routeName) {
      LoginScreenArgs argument = settings.arguments as LoginScreenArgs;
      return MaterialPageRoute(builder: (context) => LoginScreen(
        args: argument,
      ));
    }
    if (settings.name == SettingScreen.routeName) {
      return MaterialPageRoute(builder: (context) => const SettingScreen());
    }
    if (settings.name == SearchScreen.routeName) {
      return MaterialPageRoute(builder: (context) => const SearchScreen());
    }

    if (settings.name == RegisterScreen.routeName) {
      RegisterScreenArgs argument = settings.arguments as RegisterScreenArgs;
      return MaterialPageRoute(
          builder: (context) => RegisterScreen(
            args: argument,
          ));
    }
    if (settings.name == WithdrawScreen.routeName) {
      WithdrawScreenArgs argument = settings.arguments as WithdrawScreenArgs;
      return MaterialPageRoute(
          builder: (context) => WithdrawScreen(
            args: argument,
          ));
    }

    if (settings.name == ApplyScreen.routeName) {
      ApplyArgs argument = settings.arguments as ApplyArgs;
      return MaterialPageRoute(
          builder: (context) => ApplyScreen(
            args: argument,
          ));
    }
    if (settings.name == ViewNTFS.routeName) {
      NtfsDetailArgs argument = settings.arguments as NtfsDetailArgs;
      return MaterialPageRoute(
          builder: (context) => ViewNTFS(
            args: argument,
          ));
    }
    if (settings.name == CreateVacancyScreen.routeName) {
      return MaterialPageRoute(
          builder: (context) => const CreateVacancyScreen());
    }

    return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}
