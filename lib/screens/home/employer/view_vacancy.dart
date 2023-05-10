import 'package:et_job/cubits/jobs/vacancy_cubit.dart';
import 'package:et_job/cubits/jobs/vacancy_state.dart';
import 'package:et_job/models/job.dart';
import 'package:et_job/routes/shared.dart';
import 'package:et_job/screens/widgets/list_view.dart';
import 'package:et_job/screens/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../models/data.dart';
import '../../../utils/env/session.dart';
import '../../../utils/security/validator.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/show_toast.dart';

class CreateVacancyScreen extends StatefulWidget{
  static const routeName = "/create_vacancy";
  const CreateVacancyScreen({Key? key}) : super(key: key);

  @override
  State<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;
  bool _onProcess = false;
  final titleController = TextEditingController();
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }

  final _createFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Create Vacancy", appBar: AppBar(), widgets: [
        IconButton(onPressed: _openProfile,
            icon: const Icon(Icons.settings))
      ]),
      body: BlocConsumer<VacancyCubit,VacancyState>(
          listener: (context, state){
            if (state is VacancyCreatingFailed) {
              setState(() {
                _onProcess = false;
              });
              Session().logSession("VacancyLoadingFailed", state.error);
              ShowSnack(context,state.error).show();
            }
            if (state is CreatingVacancy) {
              setState(() {
                _onProcess = true;
              });
              ShowSnack(context,"Please wait...").show();
            }
            if (state is VacancyCreatedSuccessfully) {
              setState(() {
                _onProcess = false;
              });
              ShowSnack(context,state.message).show();
              Navigator.of(context).pop();
              DataTar dataTar = DataTar(itemId: 2,offset: 0);
              BlocProvider.of<VacancyCubit>(context).loadMyVacancies(dataTar);
            }

          },
          builder: (context,state){
            return Form(
                key: _createFormKey,
                child: SizedBox(
        //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        //color: ColorProvider.primaryColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(top: 5),
                  child: Container(
                    //padding: const EdgeInsets.only(top: 10, bottom: 15, right: 5, left: 5),
                    decoration: BoxDecoration(
                      //color: ColorProvider.primaryDarkColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: jobTopBar(
                                context, "Category: ", _dropDownCategory(categoryItems, _chosenCategoryValue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: formField(titleController, "Vacancy Title",Icons.title),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: formField(titleController, "Description", Icons.info),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: jobTopBar(context, "Job Type: ",
                                _dropDownType(typeItems, _chosenTypeValue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: jobTopBar(context, "Environment: ",
                                _dropDownEnvironment(envItems, _chosenEnvValue)),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: jobTopBar(context, "Qualification: ",
                                _dropDownEducation(requirementItems, _chosenRequirementValue)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: formField(titleController, "Location", Icons.location_pin),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: formField(titleController, "Experience", Icons.location_pin),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              height: 50,
                              child: Material(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                                child: ElevatedButton(
                                  onPressed: _onProcess
                                      ? null
                                      : () {
                                    final _form = _createFormKey.currentState;
                                    if (_form!.validate()) {
                                      _form.save();}
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Spacer(),
                                      Text("Publish", style: TextStyle(color: Colors.white)),
                                      Spacer()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
            );}
      )
    );
  }

  void applyForJob(BuildContext context, Vacancy vacancy){
    ShowMessage(context,"Apply","Thanks, We will let you know the result");
  }

  Widget jobProperties(
      BuildContext context, IconData icon, String name, String value) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child:
                Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 9.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              value,
              style: const TextStyle(
                //color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget formField(TextEditingController controller, String hint, IconData iconData){
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.white,
            blurRadius: 4,
            spreadRadius: 2,
            blurStyle: BlurStyle.normal)
      ]),
      child: TextFormField(
        controller: controller,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
            hintText: hint,
            filled: true,
            border:
            const OutlineInputBorder(borderSide: BorderSide.none)),
        validator: (value) =>
        hint != "Experience" ? Sanitizer().is3Length(value!) : null,
      ),
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
              color: Theme.of(context).primaryColor.withOpacity(0.3),
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
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
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

  String getJobType(JobType jobType) {
    switch (jobType) {
      case JobType.permanent:
        return "Permanent";
      case JobType.contract:
        return "Permanent";
    }
  }

  String getJobEnvironment(JobEnvironment environment) {
    switch (environment) {
      case JobEnvironment.inOffice:
        return "In Office";
      case JobEnvironment.remote:
        return "Remote";
    }
  }

  String getJobCategory(JobCategory category) {
    switch (category) {
      case JobCategory.programing:
        return "Software Development";
      case JobCategory.graphics:
        return "Graphics Designing";
    }
  }

  String getRequirement(Qualification qualification) {
    switch (qualification) {
      case Qualification.masters:
        return "Masters";
      case Qualification.degree:
        return "Degree";
      case Qualification.diploma:
        return "Diploma";
      case Qualification.any:
        return "Any";
    }
  }
  var categoryItems = <String>['Software Development', 'Graphics Designing'];
  String _chosenCategoryValue = "Software Development";

  var requirementItems = <String>['Masters', 'Degree', 'Diploma', 'Any'];
  String _chosenRequirementValue = "Masters";

  var envItems = <String>['In Office', 'Remote'];
  String _chosenEnvValue = "In Office";


  var typeItems = <String>['Permanent', 'Contract'];
  String _chosenTypeValue = "Permanent";

  Widget _dropDownEducation(List<String> data,String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenRequirementValue,
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
          _chosenRequirementValue = value!;
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
      value: _chosenEnvValue,
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
          _chosenEnvValue = value!;
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

}