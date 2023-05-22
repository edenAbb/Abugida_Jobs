
import 'dart:io';

import 'package:et_job/routes/shared.dart';
import 'package:et_job/screens/home/profile/view_cv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:provider/provider.dart';
import 'package:pspdfkit_flutter/pspdfkit.dart';

import '../../../cubits/account/account_cubit.dart';
import '../../../cubits/account/account_state.dart';
import '../../../models/user.dart';
import '../../../repository/account.dart';
import '../../../utils/env/device.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../root/root_screen.dart';
import '../../settings/setting.dart';
import '../../settings/widgets/constant.dart';
import '../../settings/widgets/profile_detail.dart';
import '../../settings/widgets/setting_menu.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/painter.dart';
import '../../widgets/show_toast.dart';
import 'package:http/http.dart' as http;

class EmployeeProfile extends StatefulWidget{
  static const routeName = "/admin_home";

  const EmployeeProfile({Key? key})
      : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> with TickerProviderStateMixin  {
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
    context.read<AccountCubit>().loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Profile",
          appBar: AppBar(), widgets: [
            IconButton(onPressed: _openProfile,
                icon: const Icon(Icons.settings))
          ]),
      body: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
        if (state is LoadOnProcess) {
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
        if (state is LoadFailed) {
          Session().logSession("VacancyLoadingFailed", state.error);
          if (state.error == 'end-session') {
            gotoSignIn(context);
          }
          return Center(child: Text(state.error));
        }
        if (state is LoadedSuccessfully) {
          return Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 160,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 150,
                    color: Theme
                        .of(context)
                        .primaryColor,
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
              SingleChildScrollView(
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Profile(state.user, 1),
                    SizedBox(
                      height: Device.deviceScreen(context) * 0.01,
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getMenuTitle("Educational Background"),
                            menuIt(Icons.cast_for_education, "Academic award",
                                state.user.education),
                            menuIt(
                                Icons.category, "Graduated in",
                                state.user.category),
                            menuIt(Icons.chair, "Working environment",
                                state.user.environment),
                            menuIt(Icons.merge_type, "Looking for job type",
                                state.user.jobType),
                            menuIt(Icons.work_history, "Experience",
                                '${state.user.experience} years'),
                            // SettingMenu(
                            //     theme: Theme.of(context).primaryColor, cat: 3),
                            //
                          ],
                        )),
                    SizedBox(
                      height: Device.deviceScreen(context) * 0.02,
                    ),
                    // Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         _getMenuTitle("Experience"),
                    //         SettingMenu(
                    //             theme: Theme.of(context).primaryColor, cat: 3),
                    //       ],
                    //     )),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getMenuTitle("Your Current File"),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("View your cv..."),
                            ),
                            Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if(state.user.cvAsPdf != null){
                                        Session().logSession("attch",
                                            state.user.cvAsPdf ?? "opps");


                                        Navigator.pushNamed(context, ViewCVScreen.routeName,
                                            arguments: ViewCVArgs(path: state.user.cvAsPdf!));
                                        //viewPdf(state.user.cvAsPdf!);
                                      }else{
                                        ShowSnack(context,
                                            "No Attachment found")
                                            .show();
                                      }
                                    },
                                    child: Text("View Files"))),

                            _getMenuTitle("Upload Your File"),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                  "Allow you to upload cv and related file"),
                            ),
                            Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      // ShowSnack(context,
                                      //     "this feature is available soon")
                                      //     .show();
                                      chooseFile();
                                    },
                                    child: Text("Upload Files")))
                          ],

                        )),
                    /*Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LikeOrNot(onLike: onLike, onDislike: onDislike),
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ],
          );
        }

        return Container(child: Center(child: Text("Unabale to load data")));
      }
    )
    );
  }

  _getMenuTitle(String menuTitle) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
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
          padding: const EdgeInsets.all(10.0),
          child: Text(menuTitle),
        ),
      ),
    );
  }
  SettingMenuItem menuIt(IconData icon,String title, String subTitle){
    var item = ProfileMenuItem(icon:icon,title: title, subTitle: subTitle);
    return SettingMenuItem(theme: Theme.of(context).primaryColor,
        cat: 3, position: 2,menu: item);
  }
  Future<void> chooseFile() async {
    // XFile? photo = (await ImagePicker.platform.getImage(source: ImageSource.gallery));
    // if(photo != null){
    //   BlocProvider.of<AccountCubit>(context).uploadProfilePhoto(photo);
    // }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      ShowSnack(context, "Please wait...").show();
      File file = File(result.files.single.path!);
      //BlocProvider.of<AccountCubit>(context).uploadCV(file);
      var sender = AccountRepository(httpClient: http.Client());
      var res = sender.uploadCV(file);
      res.then((value) => {
            ShowSnack(context, value.message).show(),
      })
          .onError((error, stackTrace) => {
        Session().logSession("login", "response $error"),
        ShowSnack(context, "$error.").show(),
      });
    } else {
      // User canceled the picker
    }
  }
  viewPdf(String path) async {
    // The URL of the PDF you want to download.
    final pdfUrl = 'https://pspdfkit.com/downloads/pspdfkit-flutter-quickstart-guide.pdf';

    // Fetch the PDF from the URL.
    final pdfResponse = await http.get(Uri.parse(path));

    // Check the response status code. If it's not `200` (OK), throw an error.
    if (pdfResponse.statusCode != 200) {
      throw Exception('Failed to download PDF');
    }

    Directory tempDir = await getTemporaryDirectory();
    final dirExists = await tempDir.exists();

    if (!dirExists) {
      await tempDir.create();
    }

    String tempPath = tempDir.path;

    // Create a file to store the PDF.
    final pdfFile = File('$tempPath/my-pdf.pdf');

    // Write the PDF data to the file.
    await pdfFile.writeAsBytes(pdfResponse.bodyBytes);

    // Use the PSPDFKit `PdfViewer` to display the PDF document.
    //final pdfDocument = await Pspdfkit.present(pdfFile.path);


    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(
          'https://github.com/espresso3389/flutter_pdf_render/raw/master/example/assets/hello.pdf'),
      builder: (context, snapshot) => snapshot.hasData
          ? PdfViewer.openFile(snapshot.data!.path)
          : Container( /* placeholder */),
    );


    //return PdfViewer.openAsset('$tempPath/my-pdf.pdf');
  }
}