import 'package:easy_localization/easy_localization.dart';
import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';
import 'package:et_job/models/transaction.dart';
import 'package:et_job/routes/shared.dart';
import 'package:et_job/screens/notifications/view_notification.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../home/employee/apply.dart';

class ListCard extends StatelessWidget {
  const ListCard({Key? key, required this.vacancy, required this.role}) : super(key: key);

  final Vacancy vacancy;
  final UserRole role;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        //padding: const EdgeInsets.only(top: 10, bottom: 15, right: 5, left: 5),
        decoration: const BoxDecoration(
          //color: ColorProvider.primaryDarkColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: role == UserRole.employee ? forEmployee(context):
        role == UserRole.employer ? forEmployer(context):
        role == UserRole.admin ? forEmployer(context):
        Container(child: Center(child: Text("Something went wrong!")),),

      ),
    );
  }


  Padding forEmployee(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          jobTopBar(
              context, "Category", getJobCategory(vacancy.jobCategory),vacancy.jobStatus),
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
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(

                  onPressed: vacancy.jobStatus != "open" ? null :() {
                    actionForEmployee(context, vacancy);
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
          jobTopBar(
              context, "Category", getJobCategory(vacancy.jobCategory),vacancy.jobStatus),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                jobProperties(
                    context, Icons.title, "Title", vacancy.jobTitle),
                jobProperties(context, Icons.info, "Description",
                    vacancy.jobDescription),
                // jobProperties(context, Icons.alarm, "Job Type",
                //     getJobType(vacancy.jobType)),
                // jobProperties(context, Icons.location_city, "Environment",
                //     getJobEnvironment(vacancy.jobEnvironment)),
                // jobProperties(context, Icons.location_pin, "Location",
                //     vacancy.jobLocation),
                // jobProperties(context, Icons.cast_for_education,
                //     "Qualification", getRequirement(vacancy.qualification)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
                  onPressed: () {
                    actionForEmployee(context, vacancy);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Spacer(),
                      Text("Manage", style: TextStyle(color: Colors.white)),
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
  Padding forAdmin(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          jobTopBar(
              context, "Category", getJobCategory(vacancy.jobCategory),vacancy.jobStatus),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                jobProperties(
                    context, Icons.title, "Title", vacancy.jobTitle),
                jobProperties(context, Icons.info, "Description",
                    vacancy.jobDescription),
                // jobProperties(context, Icons.alarm, "Job Type",
                //     getJobType(vacancy.jobType)),
                // jobProperties(context, Icons.location_city, "Environment",
                //     getJobEnvironment(vacancy.jobEnvironment)),
                // jobProperties(context, Icons.location_pin, "Location",
                //     vacancy.jobLocation),
                // jobProperties(context, Icons.cast_for_education,
                //     "Qualification", getRequirement(vacancy.qualification)),
              ],
            ),
          ),
          vacancy.jobStatus == "open" ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                  child: ElevatedButton(
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      actionForEmployee(context, vacancy);
                    },
                    child: Row(
                      ///mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //Spacer(),
                        Text("Approve", style: TextStyle(color: Colors.white)),
                        //Spacer()
                      ],
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                    onPressed: () {
                      actionForEmployee(context, vacancy);
                    },
                    child: Row(
                      ///mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //Spacer(),
                        Text("Cancel", style: TextStyle(color: Colors.white)),
                        //Spacer()
                      ],
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      actionForEmployee(context, vacancy);
                    },
                    child: Row(
                      ///mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //Spacer(),
                        Text("Disable", style: TextStyle(color: Colors.white)),
                        //Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ):
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
                child: ElevatedButton(
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
                padding: const EdgeInsets.all(3.0),
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
            padding: const EdgeInsets.all(8.0),
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

  Widget jobTopBar(BuildContext context, String name, String value, String status) {
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
          child: Row(
            children: [
              Expanded(
                child: Text(value,
                    style: const TextStyle(
                      color: Colors.black,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    //color: ColorProvider().primaryDeepTeal,
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: status == "open" ? Colors.green:Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void actionForEmployee(BuildContext context, Vacancy vacancy) {
    Navigator.pushNamed(context, ApplyScreen.routeName,
        arguments: ApplyArgs(vacancy: vacancy,role: role));
  }
  //implemented on apply screen
  void actionForEmployer(BuildContext context, Vacancy vacancy){

  }
  void actionForAdmin(BuildContext context, Vacancy vacancy){

  }
//implemented on apply screen

  String getJobType(JobType jobType) {
    switch (jobType) {
      case JobType.permanent:
        return "Permanent";
      case JobType.contract:
        return "Contract";
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

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {Key? key, required this.notification, required this.theme})
      : super(key: key);

  final JNotification notification;
  final Color theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, ViewNTFS.routeName,
            arguments: NtfsDetailArgs(notification: notification));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.only(top: 5),
        child: Container(
          decoration: const BoxDecoration(
            //color: ColorProvider.primaryDarkColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 40,
                //child: SvgPicture.asset(svgSrc),
                child: Center(
                    child: Icon(
                      notification.type == 1 ? Icons.notifications:
                      Icons.currency_bitcoin,
                  color: theme,
                  size: 50,
                )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          //color: ColorProvider.primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          notification.body,
                          style: TextStyle(
                            fontSize: 12,
                            //color: ColorProvider.primaryTextColor.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {Key? key, required this.transaction})
      : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: const BoxDecoration(
          //color: ColorProvider.primaryDarkColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 40,
              //child: SvgPicture.asset(svgSrc),
              child: Center(
                  child: Icon(
                    Icons.currency_bitcoin,
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        //color: ColorProvider.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        transaction.body,
                        style: TextStyle(
                          fontSize: 12,
                          //color: ColorProvider.primaryTextColor.withOpacity(0.5),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user})
      : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: const BoxDecoration(
          //color: ColorProvider.primaryDarkColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 40,
              //child: SvgPicture.asset(svgSrc),
              child: Center(
                  child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 50,
              )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        //color: ColorProvider.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        getUserRole(user.role),
                        style: TextStyle(
                          fontSize: 12,
                          //color: ColorProvider.primaryTextColor.withOpacity(0.5),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return "Admin";
      case UserRole.employer:
        return "Employer";
      case UserRole.employee:
        return "Employee";
      case UserRole.guest:
        return "Guest";
      case UserRole.moderator:
        return "Moderator";
    }
  }
}
