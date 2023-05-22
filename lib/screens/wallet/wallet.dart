import 'package:et_job/cubits/account/account_state.dart';
import 'package:et_job/cubits/user/user_cubit.dart';
import 'package:et_job/cubits/user/user_state.dart';
import 'package:et_job/cubits/wallet/wallet_cubit.dart';
import 'package:et_job/cubits/wallet/wallet_state.dart';
import 'package:et_job/models/transaction.dart';
import 'package:et_job/routes/shared.dart';
import 'package:et_job/screens/wallet/withdraw.dart';
import 'package:et_job/screens/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../models/data.dart';
import '../../../models/user.dart';
import '../../../repository/account.dart';
import '../../../utils/env/device.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';

import 'package:http/http.dart' as http;

import '../../cubits/wallet/wallet_b_cubit.dart';
import '../root/root_screen.dart';
import '../settings/setting.dart';
import '../widgets/app_bar.dart';
import '../widgets/list_view.dart';
import '../widgets/painter.dart';
class WalletScreen extends StatefulWidget{
  static const routeName = "/wallet_screen";

  const WalletScreen({Key? key})
      : super(key: key);

  @override
  State<WalletScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<WalletScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
    //_loadProfile();
    _initDataRequest();
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }

  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(offset: 0);
    BlocProvider.of<WalletCubit>(context).loadWalletHistory(dataTar);
    BlocProvider.of<WalletBCubit>(context).loadWalletBalance();
  }
  bool bLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Wallet", appBar: AppBar(), widgets: [
        IconButton(onPressed: _openProfile,
            icon: const Icon(Icons.settings))
      ]),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 170,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 950,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                color: Theme.of(context).primaryColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Device.deviceScreen(context) * 0.2,
                child: BlocBuilder<WalletBCubit, WalletBState>(builder: (context, state) {
                if (state is LoadingWalletBalance) {
                  return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: themeProvider.getColor,
                        ),
                      ));
                }
                if (state is WalletBalanceLoadingFailed) {
                  Session().logSession("VacancyLoadingFailed", state.error);
                  if (state.error == 'end-session') {
                    gotoSignIn(context);
                  }
                  return Center(child: Text(state.error));
                }
                if (state is WalletBalanceLoaded) {
                  return Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    child: Column(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(state.balance,
                            style: TextStyle(fontSize: 25,color: Colors.white),),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(onPressed: (){
                                ShowSnack(context,"Redirect To Chapa Payment").show();
                              },
                                  child: Column(
                                    children: [
                                      Icon(Icons.arrow_downward,size: 40,),
                                      Text("Recharge",style: TextStyle(fontSize: 10),),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(onPressed: (){
                                BlocProvider.of<WalletBCubit>(context).loadWalletBalance();
                                //ShowSnack(context,"Refresh Balance").show();
                              },
                                  child: Column(
                                    children: [
                                      Icon(Icons.refresh,size: 40,),
                                      Text("Refresh",style: TextStyle(fontSize: 10),),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(onPressed: (){
                                ShowSnack(context,"To Withdrawal page").show();

                                Navigator.pushNamed(context, WithdrawScreen.routeName,
                                    arguments: WithdrawScreenArgs(amount: "3000"));
                              },
                                  child: Column(
                                    children: [
                                      Icon(Icons.arrow_upward,size: 40,),
                                      Text("Withdraw",style: TextStyle(fontSize: 10),),
                                    ],
                                  )),
                            ),


                          ],

                        ),
                      )
                    ],)
                    );
                }
                return const Center(child: Text("No Transaction Available"));
              }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Wallet History"),
              ),
              SizedBox(
                height: Device.deviceScreen(context) * 0.58 - Device.bottomNav(context),
                child: BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
                  if (state is LoadingWalletHistory) {
                    return Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: themeProvider.getColor,
                          ),
                        ));
                  }
                  if (state is WalletHistoryLoadingFailed) {
                    Session().logSession("VacancyLoadingFailed", state.error);
                    if (state.error == 'end-session') {
                      gotoSignIn(context);
                    }
                    return Center(child: Text(state.error));
                  }
                  if (state is WalletHistoryLoaded) {
                    Session().logSession(
                        "ItemSize", state.transactions.transactions.length.toString());
                    return transactionHolder(state.transactions.transactions);
                  }
                  return const Center(child: Text("No Transaction Available"));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isLoadMoreRunning = false;
  transactionHolder(List<Transaction> transactions) {
    return transactions.isNotEmpty
        ? Column(
      children: [
        Expanded(
          child: ListView.builder(
            //controller: _controller,
              itemCount: transactions.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, item) {
                return TransactionCard(transaction: transactions[item]);
              }),
        ),
        // when the _loadMore function is running
        if (_isLoadMoreRunning == true)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Center(
              child: CircularProgressIndicator(
                color: themeProvider.getColor,
              ),
            ),
          ),
      ],
    )
        : const Center(child: Text("No Transaction made yet."));
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
}