import 'package:et_job/screens/home/employer/create_vacancy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../cubits/jobs/vacancy_cubit.dart';
import '../../../cubits/jobs/vacancy_state.dart';
import '../../../models/data.dart';
import '../../../models/job.dart';
import '../../../models/user.dart';
import '../../../repository/account.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../root/root_screen.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list_view.dart';

import 'package:http/http.dart' as http;
class VacanciesScreen extends StatefulWidget{
  static const routeName = "/admin_home";

  const VacanciesScreen({Key? key})
      : super(key: key);

  @override
  State<VacanciesScreen> createState() => _VacanciesScreenState();
}

class _VacanciesScreenState extends State<VacanciesScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadProfile();
    super.initState();
  }

  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(itemId: 2,offset: 0);
    context.read<VacancyCubit>().loadVacancies(dataTar);
    //BlocProvider.of<VacancyCubit>(context).loadVacancies(dataTar);
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }
  _createVacancy(){
    Navigator.pushNamed(context, CreateVacancyScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Vacancies", appBar: AppBar(), widgets: [
        IconButton(onPressed: _createVacancy,
            icon: const Icon(Icons.add)),
        IconButton(onPressed: _openProfile,
            icon: const Icon(Icons.settings)),
      ]),
      body: BlocBuilder<VacancyCubit, VacancyState>(builder: (context, state) {
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
              "ItemSize", state.vacancies.vacancies[0].toString());
          return vacancyHolder(state.vacancies.vacancies);
        }
        _initDataRequest();
        return const Center(child: Text("No Vacancy Available"));
      })
    );
  }

  bool _isLoadMoreRunning = false;
  vacancyHolder(List<Vacancy> vacancies) {
    Session().logSession("vacancy", "vacancyHolder");
    return vacancies.isNotEmpty
        ? Column(
      children: [
       proLoaded ? Expanded(
          child: ListView.builder(
            //controller: _controller,
              itemCount: vacancies.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, item) {
                Session().logSession("vacancy",
                    "lister role: "+user.role.name);
                return ListCard(vacancy: vacancies[item],role:user.role);
              }),
        ): Container(child: Text("Not Loaded",style: TextStyle(color: Colors.black26),),),
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

  _loadProfile() async {
    await auth.getUserData().then((value) => {
      setState(() {
        user = value;
        proLoaded = true;
        _initDataRequest();
      })
    });
  }
}