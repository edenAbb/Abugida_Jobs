import 'package:et_job/cubits/wallet/wallet_cubit.dart';
import 'package:et_job/cubits/wallet/wallet_state.dart';
import 'package:et_job/models/report.dart';
import 'package:et_job/utils/env/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../models/data.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../root/root_screen.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/painter.dart';

class EmployerHome extends StatefulWidget{
static const routeName = "/admin_home";

const EmployerHome({Key? key})
: super(key: key);

@override
State<EmployerHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<EmployerHome> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _initDataRequest();
    super.initState();
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }
  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(itemId: 1,offset: 0);
    context.read<WalletCubit>().reports("dataTar");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      appBar: JobsAppBar(key: _appBar, title: "Dashboard", appBar: AppBar(), widgets: [
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
                height: 270,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 950,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 0,
                color: Theme.of(context).primaryColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
            if (state is LoadingReports) {
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
            if (state is LoadReportFailed) {
              Session().logSession("VacancyLoadingFailed", state.error);
              if (state.error == 'end-session') {
                gotoSignIn(context);
              }
              return Center(child: Text(state.error));
            }
            if (state is ReportLoadedSuccessfully) {
              Session().logSession("reports", "loaded");
              return SizedBox(
                //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
                //color: ColorProvider.primaryColor,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0,bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                            ),
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.group,
                                        size: 20,color:Colors.white),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Vacancies",
                                        style: TextStyle(color:Colors.white,
                                            fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("",
                                      style: TextStyle(color:Colors.white,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        vacancyPanel(state.report.vacancyReport),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                            ),
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.money,
                                        size: 20,color:Colors.white),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Payments",
                                        style: TextStyle(color:Colors.white,
                                            fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("",
                                      style: TextStyle(color:Colors.white,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        transactionPanel(state.report.transactionReport),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: Theme.of(context).primaryColor.withOpacity(0.4),
                        //       shape: BoxShape.rectangle,
                        //     ),
                        //     child: SizedBox(
                        //       height: 60,
                        //       child: Row(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Icon(Icons.group,
                        //                 size: 20,color:Colors.white),
                        //           ),
                        //           Expanded(
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Text("Users",
                        //                 style: TextStyle(color:Colors.white,
                        //                     fontWeight: FontWeight.bold),),
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text("",
                        //               style: TextStyle(color:Colors.white,
                        //                   fontWeight: FontWeight.bold),),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // userPanel(state.report.userReport),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(child: Text("No Reports Available"));
          }),
        ],
      ),
    );
  }
  Padding vacancyPanel(VacancyReport vacancyReport){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              shape: BoxShape.rectangle,
            ),
            child: SizedBox(
              height: 230,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.yellow),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Open",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(vacancyReport.open,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.red),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Closed",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(vacancyReport.close,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.yellow),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("OnGoing",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(vacancyReport.ongoing,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.green),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Completed",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(vacancyReport.completed,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.purple),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Archived",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(vacancyReport.archived,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Divider(
                        height: 5,
                        thickness: 2,
                        color: Colors.white
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("More",
                      style: TextStyle(color:Colors.white,
                          fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     color: Theme.of(context).primaryColor.withOpacity(0.4),
          //     shape: BoxShape.rectangle,
          //   ),
          //   child: SizedBox(
          //     height: 170,
          //     width: MediaQuery.of(context).size.width * 0.47,
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.person,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Employee",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.work,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Employer",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.admin_panel_settings,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Admin",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(
          //             height: 5,
          //             thickness: 2,
          //             color: Colors.white
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: Text("Users",
          //             style: TextStyle(color:Colors.white,
          //                 fontWeight: FontWeight.bold),),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          //
        ],
      ),
    );
  }
  Padding transactionPanel(TransactionReport transactionReport){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              shape: BoxShape.rectangle,
            ),
            child: SizedBox(
              height: 170,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Total transaction",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(transactionReport.total,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Payments",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(transactionReport.paid,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Service Fee's",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(transactionReport.fee,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 5,
                      thickness: 2,
                      color: Colors.white
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("More",
                      style: TextStyle(color:Colors.white,
                          fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     color: Theme.of(context).primaryColor.withOpacity(0.4),
          //     shape: BoxShape.rectangle,
          //   ),
          //   child: SizedBox(
          //     height: 170,
          //     width: MediaQuery.of(context).size.width * 0.47,
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.manage_accounts_outlined,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Active",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.manage_accounts_outlined,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Active",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.manage_accounts_outlined,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Active",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(
          //             height: 5,
          //             thickness: 2,
          //             color: Colors.white
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: Text("Users",
          //             style: TextStyle(color:Colors.white,
          //                 fontWeight: FontWeight.bold),),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  Padding userPanel(UserReport userReport){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              shape: BoxShape.rectangle,
            ),
            child: SizedBox(
              height: 170,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.person,
                                  size: 20,color:Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Employee",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(userReport.employee,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.person,
                                  size: 20,color:Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Employer",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(userReport.employer,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts_outlined,
                                  size: 20,color:Colors.white),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Admins",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(userReport.admin,
                                style: TextStyle(color:Colors.white,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 5,
                      thickness: 2,
                      color: Colors.white
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("More",
                      style: TextStyle(color:Colors.white,
                          fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     color: Theme.of(context).primaryColor.withOpacity(0.4),
          //     shape: BoxShape.rectangle,
          //   ),
          //   child: SizedBox(
          //     height: 170,
          //     width: MediaQuery.of(context).size.width * 0.47,
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.manage_accounts_outlined,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Active",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.manage_accounts_outlined,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Active",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Icon(Icons.manage_accounts_outlined,
          //                         size: 20,color:Colors.white),
          //                   ),
          //                   Expanded(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text("Active",
          //                         style: TextStyle(color:Colors.white,
          //                             fontWeight: FontWeight.bold),),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("0",
          //                       style: TextStyle(color:Colors.white,
          //                           fontWeight: FontWeight.bold),),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //         Divider(
          //             height: 5,
          //             thickness: 2,
          //             color: Colors.white
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: Text("Users",
          //             style: TextStyle(color:Colors.white,
          //                 fontWeight: FontWeight.bold),),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}