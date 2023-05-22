import 'package:easy_localization/easy_localization.dart';
import 'package:et_job/cubits/account/account_cubit.dart';
import 'package:et_job/screens/account/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubits/account/account_state.dart';
import '../../models/user.dart';
import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/env/session.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../settings/widgets/profile_image.dart';
import '../widgets/app_bar.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';

import 'package:http/http.dart' as http;
class UpdateAccount extends StatefulWidget {
  static const routeName = "/update_account";

  const UpdateAccount({Key? key, required UpdateAccountArgs args})
      : super(key: key);

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();
  bool _onProcess = false;
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  final _updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(
        key: _appBar,
        title: "Update Account",
        appBar: AppBar(),
        widgets: const []),
      backgroundColor: const Color(0xFFEEEEEE),
      body: BlocConsumer<AccountCubit,AccountState>(
        listener: (context, state){
          if (state is UpdatingFailed) {
            setState(() {
              _onProcess = false;
            });
            Session().logSession("VacancyLoadingFailed", state.error);
            ShowSnack(context,state.error).show();
          }
          if (state is UpdateOnProcess) {
            setState(() {
                 _onProcess = true;
            });
            ShowSnack(context,"Please wait...").show();
          }
          if (state is UpdatedSuccessfully) {
            setState(() {
              _onProcess = false;
            });
            ShowSnack(context,state.message).show();
            BlocProvider.of<AccountCubit>(context).loadProfile();
            Navigator.pop(context);
          }

          if (state is UploadingFailed) {
            setState(() {
              _onProcess = false;
            });
            Session().logSession("VacancyLoadingFailed", state.error);
            ShowSnack(context,state.error).show();
          }
          if (state is UploadOnProcess) {
            setState(() {
              _onProcess = true;
            });
            ShowSnack(context,"Please wait...").show();
          }
          if (state is UploadedSuccessfully) {
            setState(() {
              _onProcess = false;
            });
            ShowSnack(context,state.message).show();
            BlocProvider.of<AccountCubit>(context).loadProfile();
          }


        },
        builder: (context,state){
          return Form(
              key: _updateFormKey,
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
                  proLoaded ? Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: (){
                              choosePhoto();
                            },
                            child: Center(
                              child: SizedBox(
                                //width: 100,
                                //height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      ProfileImage(
                                          height: 60.0,
                                          width: 60.0,
                                          profileUrl: "${user.profileImage}"),
                                      Text("Change",
                                        style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              //border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: fNameCtl,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100)),
                                    labelText: user.fullName,
                                    enabledBorder: InputBorder.none,
                                    labelStyle:
                                    const TextStyle(color: Colors.grey)),
                                validator: (value) =>
                                    Sanitizer().isFullNameValid(value!),
                                onSaved: (value) {},
                              ),
                              TextFormField(
                                keyboardType:
                                const TextInputType.numberWithOptions(signed: true, decimal: true),
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100)),
                                    labelText: user.phoneNumber,
                                    enabled: false,
                                    enabledBorder: InputBorder.none,
                                    labelStyle:
                                    const TextStyle(color: Colors.grey)),
                                // validator: (value) =>
                                //     Sanitizer().isPhoneValid(value!),
                                onSaved: (value) {},
                              ),
                              TextFormField(
                                controller: emailCtl,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100)),
                                    labelText: user.email,
                                    enabledBorder: InputBorder.none,
                                    labelStyle:
                                    const TextStyle(color: Colors.grey)),
                                validator: (value) =>
                                    Sanitizer().isEmailValid(value!),
                                onSaved: (value) {},
                              ),
                              isEmployee(user.role) ? Column(children: [
                                Row(
                                  children: [
                                    Icon(Icons.cast_for_education,
                                      color: Theme.of(context).primaryColor,),
                                    Expanded(
                                      child: jobTopBar(context, "Education: ",
                                          _dropDownEducation(education,
                                              _chosenEducationValue)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.category,
                                      color: Theme.of(context).primaryColor,),
                                    Expanded(
                                      child: jobTopBar(context, "Category: ",
                                          _dropDownCategory(category,
                                              _chosenCategoryValue)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.chair,
                                      color: Theme.of(context).primaryColor,),
                                    Expanded(
                                      child: jobTopBar(context, "Environment: ",
                                          _dropDownEnvironment(environment,
                                              _chosenEnvironmentValue)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.merge_type,
                                      color: Theme.of(context).primaryColor,),
                                    Expanded(
                                      child: jobTopBar(context, "Job Type: ",
                                          _dropDownType(jobType, _chosenTypeValue)),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  keyboardType: const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  controller: expCtl,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.work_history,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
                                      labelText: '${user.experience} years',
                                      suffix: Text("experience"),
                                      enabledBorder: InputBorder.none,
                                      labelStyle:
                                      const TextStyle(color: Colors.grey)),
                                  onSaved: (value) {},
                                ),
                              ],) : Container()
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(90, 0, 20, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        final _form = _updateFormKey.currentState;
                                        if (_form!.validate()) {
                                          _form.save();
                                          Session().logSession("update", "clicked");
                                          bool update = false;
                                          if(fNameCtl.text != user.fullName){
                                            user.fullName = fNameCtl.text;
                                            update = true;
                                          }
                                          if(emailCtl.text != user.email){
                                            user.email = emailCtl.text;
                                            update = true;
                                          }

                                          if(_chosenCategoryValue != user.category){
                                            Session().logSession("update", "category");
                                            user.category = _chosenCategoryValue;
                                            update = true;
                                          }
                                          if(_chosenTypeValue != user.jobType){
                                            Session().logSession("update",
                                                "type changed to $_chosenTypeValue  from ${user.jobType}");
                                            user.jobType = _chosenTypeValue;
                                            update = true;
                                          }
                                          if(_chosenEnvironmentValue != user.environment){
                                            Session().logSession("update", "environment");
                                            user.environment = _chosenEnvironmentValue;
                                            update = true;
                                          }
                                          if(_chosenEducationValue != user.education){
                                            Session().logSession("update", "education");
                                            user.education = _chosenEducationValue;
                                            update = true;
                                          }
                                          if(expCtl.text != user.experience){
                                            Session().logSession("update", "experience");
                                            user.experience = expCtl.text;
                                            update = true;
                                          }



                                          if(update){
                                            setState(() {
                                              _onProcess = true;
                                            });
                                            //ShowSnack(context,"Please Wait...").show();
                                            prepareRequest(context);
                                          }else{
                                            ShowSnack(context,"Nothing to update").show();
                                          }
                                        }else{
                                          Session().logSession("update", "validation error");
                                        }

                                      },
                                      child: const Center(
                                        child: Text(
                                          "UPDATE",
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
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            ColorProvider().primaryDarkColor
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                ),
                              ) /*,
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
                        Container(
                          margin: const EdgeInsets.fromLTRB(90, 30, 20, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            ChangePassword.routeName,
                                            arguments:
                                            ChangePasswordArgs(isOnline: true));
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Change Password",
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
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            ColorProvider().primaryDarkColor
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                ),
                              ) /*,
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
                  ):Container()
                ],
              ));
        }
    ),
    );
  }
  var proLoaded = false;

  late User user;
  _loadProfile() {
    var auth = AccountRepository(httpClient: http.Client());
    //UserProvider userProvider = UserProvider(authRepository: auth);
    auth.getUserData().then((value) => {
      setState(() {
        user = value;
        proLoaded = true;
        fNameCtl.text = user.fullName;
        emailCtl.text = user.email ?? "";

        expCtl.text = user.experience ?? "Unavailable";

        eduCtl.text = user.education ?? "Unavailable";
        typeCtl.text = user.jobType ?? "Unavailable";
        envCtl.text = user.environment ?? "Unavailable";
        catCtl.text = user.category ?? "Unavailable";

        _chosenEducationValue = eduCtl.text;
        _chosenEnvironmentValue = envCtl.text;
        _chosenTypeValue = typeCtl.text;
        _chosenCategoryValue = catCtl.text;
      })
    });
  }


  void prepareRequest(BuildContext context) {
    BlocProvider.of<AccountCubit>(context).update(user);
    // var sender = AccountRepository(httpClient: http.Client());
    // //Session().logSession("login", "http client");
    // setState(() {
    //   _onProcess = true;
    // });
    // //var res = sender.fakeLogin(_doctor["password"]);
    // var res = sender.updateUser(user);
    // res.then((value) => {
    //   setState(() {
    //     _onProcess = false;
    //   }),
    //   ShowSnack(context, value.message).show()
    // })
    //     .onError((error, stackTrace) => {
    //   Session().logSession("login", "response $error"),
    //   setState(() {
    //     _onProcess = false;
    //   }),
    // });
  }

  var fNameCtl = TextEditingController();
  var emailCtl = TextEditingController();
  var expCtl = TextEditingController();
  var eduCtl = TextEditingController();
  var typeCtl = TextEditingController();
  var envCtl = TextEditingController();
  var catCtl = TextEditingController();
  var education = <String>['Masters', 'Degree', 'Diploma', 'Other',"Unavailable"];
  String _chosenEducationValue = "Unavailable";

  var environment = <String>['Remote', 'Office',"Unavailable"];
  String _chosenEnvironmentValue = "Unavailable";

  var category = <String>['Software Development', 'Graphics Designing',"Unavailable"];
  String _chosenCategoryValue = "Unavailable";

  var jobType = <String>['Permanent', 'Contract',"Unavailable"];
  String _chosenTypeValue = "Unavailable";


  Widget _dropDownEducation(List<String> data,String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenEducationValue,
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
          _chosenEducationValue = value!;
        });
      },
    );
  }
  Widget _dropDownEnvironment(List<String> data,String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenEnvironmentValue,
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
          _chosenEnvironmentValue = value!;
        });
      },
    );
  }
  Widget _dropDownCategory(List<String> data,String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenCategoryValue,
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
          _chosenCategoryValue = value!;
        });
      },
    );
  }
  Widget _dropDownType(List<String> data,String chosen) {
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
  bool isEmployee(UserRole role){
    return role == UserRole.employee;
  }

  Future<void> choosePhoto() async {
    XFile? photo = (await ImagePicker.platform.getImage(source: ImageSource.gallery));
    if(photo != null){
      BlocProvider.of<AccountCubit>(context).uploadProfilePhoto(photo!);
    }
  }
}
