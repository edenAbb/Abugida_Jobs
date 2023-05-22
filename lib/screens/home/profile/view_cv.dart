
import 'dart:io';

import 'package:et_job/routes/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/theme_provider.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';

class ViewCVScreen extends StatefulWidget{
  static const routeName = "/cv_view";

  final ViewCVArgs args;
  const ViewCVScreen({Key? key,required this.args})
      : super(key: key);

  @override
  State<ViewCVScreen> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<ViewCVScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "CV",
          appBar: AppBar(), widgets: [
            IconButton(onPressed: _openProfile,
                icon: const Icon(Icons.settings))
          ]),
      body: SizedBox(
        //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        //color: ColorProvider.primaryColor,
        height: MediaQuery.of(context).size.height,
        //child: SingleChildScrollView(
          child: FutureBuilder<File>(
            future: DefaultCacheManager().getSingleFile(widget.args.path),
            builder: (context, snapshot) => snapshot.hasData
                ? PdfViewer.openFile(snapshot.data!.path)
                : Center(child: Container( child: const Text("Unable to load atachment"))),
          ),
        //),
      ),
    );
  }

}