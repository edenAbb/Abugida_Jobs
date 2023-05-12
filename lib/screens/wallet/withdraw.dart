import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/env/session.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/theme_provider.dart';
import '../root/root_screen.dart';
import '../widgets/app_bar.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class WithdrawScreen extends StatefulWidget {
  static const routeName = "/withdraw";
  final WithdrawScreenArgs args;
  const WithdrawScreen({Key? key, required this.args})
      : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final accountController = TextEditingController();
  final amountController = TextEditingController();

  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;
  var invisible = false;

  void changeSate() {
    if (invisible) {
      setState(() {
        invisible = false;
      });
    } else {
      setState(() {
        invisible = true;
      });
    }
  }

  bool _onProcess = false;
  final _registerFormKey = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: JobsAppBar(key: _appBar, title: "Withdraw",
        appBar: AppBar(), widgets: []),
        backgroundColor: const Color(0xFFEEEEEE),
        body: Form(
          key: _registerFormKey,
          child: Stack(
            children: <Widget>[
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
                  height: 150,
                  color: Theme.of(context).primaryColor,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: ListView(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.fromLTRB(20, 100, 20, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            //width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              shape: BoxShape.rectangle,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Balance: ${widget.args.amount}"),//Image.asset("assets/icons/icon.png"),
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            controller: accountController,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.wallet_membership,
                                  color: Theme.of(context).primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                                labelText: "Account No.",
                                enabledBorder: InputBorder.none,
                                labelStyle:
                                    const TextStyle(color: Colors.grey)),
                            validator: (value) =>
                                Sanitizer().isBankAccountValid(value!),
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            controller: amountController,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.monetization_on,
                                  color: Theme.of(context).primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                                labelText: "Amount",
                                enabledBorder: InputBorder.none,
                                labelStyle:
                                    const TextStyle(color: Colors.grey)),
                            validator: (value) =>
                                Sanitizer().canWithdraw(widget.args.amount,value!),
                          ),
                          Row(
                            children: [
                              Icon(Icons.open_with,
                                color: Theme.of(context).primaryColor,),
                              Expanded(
                                child: jobTopBar(context, "Through: ",
                                    _dropDownItem(typeItems, _chosenTypeValue)),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onProcess
                              ? null
                              : () {
                                  final _form = _registerFormKey.currentState;
                                  if (_form!.validate()) {
                                    setState(() {
                                      _onProcess = true;
                                    });
                                    _form.save();
                                    ShowSnack(context,"Available Soon").show();
                                    //prepareRequest(context);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const Text("WITHDRAW",
                                  style: TextStyle(color: Colors.white)),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: _onProcess
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void prepareRequest(BuildContext context) {
    final Map<String, dynamic> _user = {};
    _user['account_number'] = accountController.text;
    _user['amount'] = amountController.text;
    _user['bank'] = getRole(_chosenTypeValue);
    var sender = AccountRepository(httpClient: http.Client());
    Session().logSession("login", "http client");
    setState(() {
      _onProcess = true;
    });

    //var res = sender.fakeRegister(_user);
    // var res = sender.registerUser(_user);
    // res
    //     .then((value) => {
    //           Session().logSession("register", "success ${value.message}"),
    //           setState(() {
    //             _onProcess = false;
    //           }),
    //           if (value.code == "200")
    //             {
    //               //_openHomeScreen(getRoleEn(_chosenTypeValue))
    //             }
    //           else
    //             {
    //               ShowSnack(context, value.message).show(),
    //             }
    //         })
    //     .onError((error, stackTrace) => {
    //           Session().logSession("register", "error $error"),
    //           setState(() {
    //             _onProcess = false;
    //           })
    //         });
  }

  _openHomeScreen(UserRole role) {
    HomeScreenArgs argument = HomeScreenArgs(userRole: role);
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (Route<dynamic> route) => false,
        arguments: argument);
  }

  var typeItems = <String>['CBE', 'Absiniya Bank','Zemen Bank'];
  String _chosenTypeValue = "CBE";


  Widget _dropDownItem(List<String> data, String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenTypeValue,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.blue,
      items: data.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "Please choose ",
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenTypeValue = value!;
        });
      },
    );
  }
  Widget jobTopBar(BuildContext context, String name, Widget value) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,//Theme.of(context).primaryColor.withOpacity(0.3),
              /*blurRadius: 3.0,
              // has the effect of softening the shadow
              spreadRadius:
              2.0, */ // has the effect of extending the shadow
            ),
          ],
          //color: _themeColor(theme),
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(name,
                  style: const TextStyle(
                    color: Colors.black,
                  )),
            ),
            value
          ],
        ),
      ),
    );
  }
}
