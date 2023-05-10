import 'package:flutter/material.dart';

import '../../routes/shared.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import 'reset_password.dart';

class ConfirmCode extends StatefulWidget {
  static const routeName = "/confirm_code";
  final ConfirmCodeArgs args;
  const ConfirmCode({Key? key, required this.args}) : super(key: key);
  @override
  State<ConfirmCode> createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  bool _onProcess = false;
  final codeControl = TextEditingController();
  final _confirmFormKey = GlobalKey<FormState>();
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: HelloAppBar(key: _appBar, title: "confirm_code", appBar: AppBar(), widgets: const []),
      body: Container(

      ),
    );
    */
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Form(
          key: _confirmFormKey,
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
                      margin: const EdgeInsets.fromLTRB(20, 300, 20, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        children:  <Widget>[
                          TextFormField(
                            controller: codeControl,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.vpn_key,
                                  color: Theme.of(context).primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade100 )),
                                labelText: "Code",
                                enabledBorder: InputBorder.none,
                                labelStyle: const TextStyle(color: Colors.grey)),
                            validator: (value) => Sanitizer().isVerificationCodeValid(value!),
                            onSaved: (value) {

                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40,
                            child: Container(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColor,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.amber,
                                  onTap: _onProcess
                                      ? null
                                      : () {
                                    final _form = _confirmFormKey.currentState;
                                    if (_form!.validate()) {
                                      setState(() {
                                        _onProcess = true;
                                      });
                                      _form.save();
                                      Navigator.pushNamed(
                                          context, ResetPassword.routeName,
                                          arguments: ResetPasswordArgs(phone: widget.args.phone));
                                    }

                                  },
                                  child: const Center(
                                    child: Text(
                                      "CONFIRM",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [Theme.of(context).primaryColor,
                                        ColorProvider().primaryDarkColor],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                          )/*,
                      FloatingActionButton(
                        onPressed: () {},
                        mini: true,
                        elevation: 0,
                        child: const Image(
                          image: AssetImage("assets/facebook2.png"),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        mini: true,
                        elevation: 0,
                        child: const Image(
                          image: AssetImage("assets/twitter.png"),
                        ),
                      ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

}
