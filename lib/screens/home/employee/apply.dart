import 'package:et_job/models/job.dart';
import 'package:et_job/models/user.dart';
import 'package:et_job/routes/shared.dart';
import 'package:et_job/screens/widgets/list_view.dart';
import 'package:et_job/screens/widgets/show_dialog.dart';
import 'package:et_job/screens/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../cubits/jobs/vacancy_cubit.dart';
import '../../../cubits/jobs/vacancy_state.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';

class ApplyScreen extends StatefulWidget{
  static const routeName = "/apply_for_job";
  final ApplyArgs args;
  const ApplyScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;
  late Vacancy vacancy;
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
    vacancy = widget.args.vacancy;
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }
  bool _onProcess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Apply", appBar: AppBar(), widgets: [
        IconButton(onPressed: _openProfile,
            icon: const Icon(Icons.settings))
      ]),
      body: BlocConsumer<VacancyCubit,VacancyState>(
          listener: (context, state){
            if (state is VacancyUpdatingFailed) {
              setState(() {
                _onProcess = false;
              });
              Session().logSession("VacancyLoadingFailed", state.error);
              ShowSnack(context,state.error).show();
            }
            if (state is UpdatingVacancy) {
              setState(() {
                _onProcess = true;
              });
              ShowSnack(context,"Please wait...").show();
            }
            if (state is VacancyUpdatedSuccessfully) {
              setState(() {
                _onProcess = false;
              });
              ShowSnack(context,state.message).show();
              //Navigator.of(context).pop();
              //DataTar dataTar = DataTar(itemId: 2,offset: 0);
              //BlocProvider.of<VacancyCubit>(context).loadMyVacancies(dataTar);
            }

          },
          builder: (context,state){
            return SizedBox(
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

                          child: widget.args.role == UserRole.employee ? forEmployee(context):
                          widget.args.role == UserRole.employer ? forEmployer(context):
                          widget.args.role == UserRole.admin ? forAdmin(context):Container(),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      )
    );
  }
  Padding forEmployee(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          jobTopBar(
              context, "Category", getJobCategory(vacancy.jobCategory)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                jobProperties(
                    context, Icons.title, "Title", vacancy.jobTitle),
                jobProperties(context, Icons.info, "Description",
                    vacancy.jobDescription),
                jobProperties(context, Icons.alarm, "Job Type",
                    getJobType(vacancy.jobType)),
                jobProperties(context, Icons.location_city, "Environment",
                    getJobEnvironment(vacancy.jobEnvironment)),
                jobProperties(context, Icons.location_pin, "Location",
                    vacancy.jobLocation),
                jobProperties(context, Icons.cast_for_education,
                    "Qualification", getRequirement(vacancy.qualification)),
                jobProperties(context, Icons.timelapse,
                    "Experience", '${vacancy.experience} years'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    blurRadius: 4,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal)
              ]),
              child: TextFormField(
                //controller: description,
                minLines: 4,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Tell us why we should hire you",
                    filled: true,
                    border:
                    const OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
          ),
          vacancy.jobStatus == "open" ? Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: () {
                    applyForJob(context, vacancy);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Spacer(),
                      Text("Apply", style: TextStyle(color: Colors.white)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ):Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  onPressed: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Spacer(),
                      Text("Closed", style: TextStyle(color: Colors.white)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Padding forEmployer(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          jobTopBar(context, "Category", getJobCategory(vacancy.jobCategory)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                jobProperties(
                    context, Icons.title, "Title", vacancy.jobTitle),
                jobProperties(context, Icons.info, "Description",
                    vacancy.jobDescription),
                jobProperties(context, Icons.alarm, "Job Type",
                    getJobType(vacancy.jobType)),
                jobProperties(context, Icons.location_city, "Environment",
                    getJobEnvironment(vacancy.jobEnvironment)),
                jobProperties(context, Icons.location_pin, "Location",
                    vacancy.jobLocation),
                jobProperties(context, Icons.cast_for_education,
                    "Qualification", getRequirement(vacancy.qualification)),
                jobProperties(context, Icons.timelapse,
                    "Experience", '${vacancy.experience} years'),
              ],
            ),
          ),
          vacancy.jobStatus == "open" ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Material(
                //   borderRadius: BorderRadius.circular(15),
                //   color: Colors.transparent,
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(Colors.green)),
                //     onPressed: () {
                //       applyForJob(context, vacancy);
                //     },
                //     child: Row(
                //       ///mainAxisAlignment: MainAxisAlignment.center,
                //       children: const [
                //         //Spacer(),
                //         Text("Approve", style: TextStyle(color: Colors.white)),
                //         //Spacer()
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                        onPressed: () {
                          publishVacancy(context, vacancy,2);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Close", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red)),
                        onPressed: () {
                          publishVacancy(context, vacancy, 5);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            //Spacer(),
                            Text("Disable", style: TextStyle(color: Colors.white)),
                            //Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              : vacancy.jobStatus == "closed" ?
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: (){
                    publishVacancy(context, vacancy,1);
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
          )
              : vacancy.jobStatus == "ongoing" ?
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: null
                  //     (){
                  //   publishVacancy(context, vacancy,1);
                  //   ShowSnack(context,"Reopening is disabled for moment").show();
                  // }
                  ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Spacer(),
                      Text("Cancel", style: TextStyle(color: Colors.white)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ):
            vacancy.jobStatus == "completed" ?
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: (){
                    publishVacancy(context, vacancy,5);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Spacer(),
                      Text("Pay", style: TextStyle(color: Colors.white)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ):
            vacancy.jobStatus == "archived" ?
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                  child: ElevatedButton(
                    onPressed: (){
                      publishVacancy(context, vacancy,1);
                      ShowSnack(context,"Reopening is disabled for moment").show();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Spacer(),
                        Text("Archive", style: TextStyle(color: Colors.white)),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
            ):Container()
        ],
      ),
    );
  }

  Padding forAdmin(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          jobTopBar(
              context, "Category", getJobCategory(vacancy.jobCategory)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                jobProperties(
                    context, Icons.title, "Title", vacancy.jobTitle),
                jobProperties(context, Icons.info, "Description",
                    vacancy.jobDescription),
                jobProperties(context, Icons.alarm, "Job Type",
                    getJobType(vacancy.jobType)),
                jobProperties(context, Icons.location_city, "Environment",
                    getJobEnvironment(vacancy.jobEnvironment)),
                jobProperties(context, Icons.location_pin, "Location",
                    vacancy.jobLocation),
                jobProperties(context, Icons.cast_for_education,
                    "Qualification", getRequirement(vacancy.qualification)),
                jobProperties(context, Icons.timelapse,
                    "Experience", '${vacancy.experience} years'),
              ],
            ),
          ),
          vacancy.jobStatus == "open" ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          applyForJob(context, vacancy);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            //Spacer(),
                            Text("Approve", style: TextStyle(color: Colors.white)),
                            //Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                        onPressed: () {
                          applyForJob(context, vacancy);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            //Spacer(),
                            Text("Deny", style: TextStyle(color: Colors.white)),
                            //Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Material(
                //   borderRadius: BorderRadius.circular(15),
                //   color: Colors.transparent,
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(Colors.red)),
                //     onPressed: () {
                //       applyForJob(context, vacancy);
                //     },
                //     child: Row(
                //       ///mainAxisAlignment: MainAxisAlignment.center,
                //       children: const [
                //         //Spacer(),
                //         Text("Disable", style: TextStyle(color: Colors.white)),
                //         //Spacer()
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ):Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  onPressed: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Spacer(),
                      Text("Closed", style: TextStyle(color: Colors.white)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void applyForJob(BuildContext context, Vacancy vacancy){
    ShowMessage(context,"Apply","Thanks, We will let you know the result");
  }
  void publishVacancy(BuildContext context, Vacancy vacancy, int target){
    String status = vacancy.jobStatus;
    switch(target){
      case 1:
        status = "open";
        break;
      case 2:
        status = "closed";
        break;
      case 3:
        status = "ongoing";
        break;
      case 4:
        status = "complete";
        break;
      case 5:
        status = "archive";
        break;
    }
    vacancy.jobStatus = status;
    ShowSnack(context,"This feature is not available for moment").show();
    if(!_onProcess){
      //BlocProvider.of<VacancyCubit>(context).updateVacancy(vacancy);
    }else{

    }
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
                child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
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

  Widget jobTopBar(BuildContext context, String name, String value) {
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(value,
              style: const TextStyle(
                color: Colors.black,
              )),
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
}