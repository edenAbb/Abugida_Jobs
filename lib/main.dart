import 'package:et_job/cubits/account/account_cubit.dart';
import 'package:et_job/cubits/jobs/vacancy_cubit.dart';
import 'package:et_job/cubits/notification/notification_cubit.dart';
import 'package:et_job/cubits/wallet/wallet_cubit.dart';
import 'package:et_job/repository/account.dart';
import 'package:et_job/repository/notification.dart';
import 'package:et_job/repository/users.dart';
import 'package:et_job/repository/vacancy.dart';
import 'package:et_job/repository/wallet.dart';
import 'package:et_job/screens/widgets/list_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'cubits/user/user_cubit.dart';
import 'routes/routes.dart';
import 'utils/network/network.dart';
import 'utils/theme/theme_provider.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  NetworkManager connectionStatus = NetworkManager.getInstance();
  connectionStatus.initialize();

  AccountRepository accountRepository =
      AccountRepository(httpClient: http.Client());
  VacancyRepository vacancyRepository =
      VacancyRepository(httpClient: http.Client());
  NotificationRepository notificationRepository =
      NotificationRepository(httpClient: http.Client());
  UserRepository userRepository = UserRepository(httpClient: http.Client());
  WalletRepository walletRepository = WalletRepository(httpClient: http.Client());

  const secureStorage = FlutterSecureStorage();
  String? theme = await secureStorage.read(key: "theme");
  await Future.delayed(const Duration(milliseconds: 500));
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(theme: int.parse(theme ?? "1")),
      child: EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('am', 'ET')],
          path: 'assets/translations',
          // <-- change the path of the translation files
          fallbackLocale: const Locale('en', 'US'),
          child: MyApp(
            accountRepository: accountRepository,
            vacancyRepository: vacancyRepository,
            notificationRepository: notificationRepository,
            userRepository: userRepository,
            walletRepository: walletRepository,
          ))));
}

class MyApp extends StatelessWidget {
  final AccountRepository accountRepository;
  final VacancyRepository vacancyRepository;
  final NotificationRepository notificationRepository;
  final UserRepository userRepository;
  final WalletRepository walletRepository;

  const MyApp(
      {Key? key,
      required this.accountRepository,
      required this.vacancyRepository,
      required this.notificationRepository,
      required this.userRepository,
      required this.walletRepository
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    context.setLocale(const Locale('en', 'US'));
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AccountCubit(accountRepository: accountRepository)),
          BlocProvider(
              create: (context) =>
                  VacancyCubit(vacancyRepository: vacancyRepository)),
          BlocProvider(
              create: (context) => NotificationCubit(
                  notificationRepository: notificationRepository)),
          BlocProvider(
              create: (context) => UserCubit(userRepository: userRepository)),
          BlocProvider(
              create: (context) => WalletCubit(walletRepository: walletRepository)),

        ],
        child:
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: tr('title'),
            theme: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                    suffixIconColor: themeProvider.getColor,
                    prefixIconColor: themeProvider.getColor,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: themeProvider.getColor, width: 2.0),
                    ),
                    focusColor: themeProvider.getColor),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.white,
                    sizeConstraints:
                        const BoxConstraints(minWidth: 80, minHeight: 80),
                    extendedPadding: const EdgeInsets.all(50),
                    foregroundColor: themeProvider.getColor,
                    extendedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w300)),

                //F48221
                primaryColor: themeProvider.getColor,
                textTheme: const TextTheme(
                    button: TextStyle(
                      fontFamily: 'Sifonn',
                      color: Color.fromRGBO(254, 79, 5, 1),
                    ),
                    subtitle1: TextStyle(color: Colors.black38, fontSize: 14),
                    headline5: TextStyle(
                        fontFamily: 'Sifonn',
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    bodyText2: TextStyle(
                        fontFamily: 'Sifonn',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                textButtonTheme: TextButtonThemeData(
                    style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                          fontFamily: 'Sifonn', color: Colors.black)),
                )),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(
                              fontFamily: 'Sifonn',
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          themeProvider.getColor),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                ),
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.orange,
                ).copyWith(secondary: Colors.grey.shade600)),
            onGenerateRoute: AppRoute
                .generateRoute, // This trailing comma makes auto-formatting nicer for build methods.
          );
        }));
  }
}
