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

class ApplyingVacancy extends VacancyState{}
class AppliedSuccessfully extends VacancyState{
  final String message;
  AppliedSuccessfully({required this.message});
}
class ApplyingVacancyFailed extends VacancyState{
  final String error;
  ApplyingVacancyFailed({required this.error});
}


class AcceptingVacancy extends VacancyState{}
class AcceptedSuccessfully extends VacancyState{
  final String message;
  AcceptedSuccessfully({required this.message});
}
class AcceptingVacancyFailed extends VacancyState{
  final String error;
  AcceptingVacancyFailed({required this.error});
}

class CancelingVacancy extends VacancyState{}
class CanceledSuccessfully extends VacancyState{
  final String message;
  CanceledSuccessfully({required this.message});
}
class CancelingVacancyFailed extends VacancyState{
  final String error;
  CancelingVacancyFailed({required this.error});
}

class CompletingVacancy extends VacancyState{}
class CompletedSuccessfully extends VacancyState{
  final String message;
  CompletedSuccessfully({required this.message});
}
class CompletingVacancyFailed extends VacancyState{
  final String error;
  CompletingVacancyFailed({required this.error});
}



