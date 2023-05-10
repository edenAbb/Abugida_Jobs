
import 'package:et_job/screens/home/admin/home.dart';
import 'package:et_job/screens/home/admin/jobs.dart';
import 'package:et_job/screens/home/admin/users.dart';
import 'package:et_job/screens/home/employer/dashboard.dart';
import 'package:et_job/screens/home/employer/vacancies.dart';
import 'package:et_job/screens/home/profile/employee.dart';
import 'package:et_job/screens/home/profile/employer.dart';
import 'package:et_job/screens/wallet/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/theme/theme_provider.dart';
import '../account/login.dart';
import '../home/admin/transactions.dart';
import '../home/employee/jobs.dart';
import '../notifications/notifications.dart';
import 'cubit/botttom_nav_cubit.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";
  final HomeScreenArgs args;

  const HomeScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();
  late HomeScreenArgs args;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    args = widget.args;
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadProfile();
    super.initState();
  }

  final _employeeNavigation = [
    const JobsScreen(),
    const NotificationPage(),
    const WalletScreen(),
    const EmployeeProfile(),
  ];
  final _employerNavigation = [
    const EmployerHome(),
    const VacanciesScreen(),
    const NotificationPage(),
    const WalletScreen(),
  ];

  final _aPageNavigation = [
    const AdminHome(),
    const TransactionScreen(),
    const PostedJobsScreen(),
    const AppUsersScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  var proLoaded = false;
  late User user;
  var auth = AccountRepository(httpClient: http.Client());

  _loadProfile() {
    auth.getUserData().then((value) => {
          setState(() {
            user = value;
            proLoaded = true;
          })
        });
  }


  Widget _buildBody(int index) {
    switch(args.userRole){
      case UserRole.admin:
        return _aPageNavigation.elementAt(index);
      case UserRole.employer:
        return _employerNavigation.elementAt(index);
      case UserRole.employee:
        return _employeeNavigation.elementAt(index);
      case UserRole.moderator:
        return _aPageNavigation.elementAt(index);
      case UserRole.guest:
        return _aPageNavigation.elementAt(index);
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
        currentIndex: context.read<BottomNavCubit>().state,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black26,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        elevation: 2,
        onTap: _getChangeBottomNav,
        items: args.userRole == UserRole.admin ? _adminMenus() : args.userRole == UserRole.employer ? _employerMenus() : _employeeMenus());
  }

  _adminMenus() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: "Transaction"),
      const BottomNavigationBarItem(icon: Icon(Icons.list), label: "Jobs"),
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
    ];
  }

  _employerMenus() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Jobs'),
      const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
      const BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
    ];
  }

  _employeeMenus() {
    return [
      const BottomNavigationBarItem(
          icon: Icon(Icons.task), label: 'Jobs'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.notification_important), label: 'Notification'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.wallet), label: 'Wallet'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ];
  }

  void _getChangeBottomNav(int index) {
    context.read<BottomNavCubit>().updateIndex(index);
  }
}

void gotoSignIn(BuildContext context) {
  var auth = AccountRepository(httpClient: http.Client());
  auth.logOut();
  LoginScreenArgs argument = LoginScreenArgs(isOnline: true);
  Navigator.pushNamedAndRemoveUntil(
      context, LoginScreen.routeName, (Route<dynamic> route) => false,
      arguments: argument);
}
