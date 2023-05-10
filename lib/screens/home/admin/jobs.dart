import 'package:et_job/cubits/jobs/vacancy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../cubits/jobs/vacancy_cubit.dart';
import '../../../models/data.dart';
import '../../../models/job.dart';
import '../../../models/user.dart';
import '../../../repository/account.dart';
import '../../../utils/env/device.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../root/root_screen.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list_view.dart';
import '../../widgets/painter.dart';
import '../../widgets/show_dialog.dart';
import 'package:http/http.dart' as http;

class PostedJobsScreen extends StatefulWidget {
  static const routeName = "/admin_home";

  const PostedJobsScreen({Key? key}) : super(key: key);

  @override
  State<PostedJobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<PostedJobsScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
    _loadProfile();
    _initDataRequest();
  }

  _openProfile() {
    Navigator.pushNamed(context, SettingScreen.routeName);
  }

  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(itemId: 1,offset: 0);
    context.read<VacancyCubit>().loadVacancies(dataTar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Posted Jobs", appBar: AppBar(), widgets: [
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
                height: 370,
                color: Theme.of(context).primaryColor,
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
          BlocBuilder<VacancyCubit, VacancyState>(builder: (context, state) {
            if (state is LoadingVacancy) {
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
            if (state is VacancyLoadingFailed) {
              Session().logSession("VacancyLoadingFailed", state.error);
              if (state.error == 'end-session') {
                gotoSignIn(context);
              }
              return Center(child: Text(state.error));
            }
            if (state is VacancyLoaded) {
              Session().logSession(
                  "ItemSize", state.vacancies.vacancies.length.toString());
              return vacancyHolder(state.vacancies.vacancies);
            }
            return const Center(child: Text("No Vacancy Available"));
          }),
        ],
      ),
    );
  }

  bool _isLoadMoreRunning = false;
  vacancyHolder(List<Vacancy> vacancies) {
    return vacancies.isNotEmpty
        ? Column(
            children: [
              proLoaded ? Expanded(
                child: ListView.builder(
                    //controller: _controller,
                    itemCount: vacancies.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, item) {
                      return ListCard(vacancy: vacancies[item],role:user.role);
                    }),
              ):Container(),
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
        : const Center(child: Text("No Vacancy found"));
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
