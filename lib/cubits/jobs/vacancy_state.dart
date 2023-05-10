import 'package:et_job/models/job.dart';

class VacancyState{}
class VacancyInit extends VacancyState{}

class LoadingVacancy extends VacancyState{}
class VacancyLoaded extends VacancyState{
  final Vacancies vacancies;
  VacancyLoaded({required this.vacancies});
}
class VacancyLoadingFailed extends VacancyState{
  final String error;
  VacancyLoadingFailed({required this.error});
}

class UpdatingVacancy extends VacancyState{}
class VacancyUpdatedSuccessfully extends VacancyState{
  final String message;
  VacancyUpdatedSuccessfully({required this.message});
}
class VacancyUpdatingFailed extends VacancyState{
  final String error;
  VacancyUpdatingFailed({required this.error});
}

class CreatingVacancy extends VacancyState{}
class VacancyCreatedSuccessfully extends VacancyState{
  final String message;
  VacancyCreatedSuccessfully({required this.message});
}
class VacancyCreatingFailed extends VacancyState{
  final String error;
  VacancyCreatingFailed({required this.error});
}

class RemovingVacancy extends VacancyState{}
class VacancyRemovedSuccessfully extends VacancyState{
  final String message;
  VacancyRemovedSuccessfully({required this.message});
}
class RemovingVacancyFailed extends VacancyState{
  final String error;
  RemovingVacancyFailed({required this.error});
}
