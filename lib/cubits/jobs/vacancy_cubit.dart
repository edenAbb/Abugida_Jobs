
import 'package:et_job/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/job.dart';
import '../../repository/vacancy.dart';
import 'vacancy_state.dart';

class VacancyCubit extends Cubit<VacancyState>{
  VacancyRepository vacancyRepository;
  VacancyCubit({required this.vacancyRepository})  : super(VacancyInit());
  Future<void> loadVacancies(DataTar dataTar) async {
    emit(LoadingVacancy());
    try{
      var vacancies = await vacancyRepository.loadVacancies(dataTar);
      //var vacancies = await vacancyRepository.fakeVacancies(dataTar);
      emit(VacancyLoaded(vacancies: vacancies));
    }catch(e){
      emit(VacancyLoadingFailed(error: e.toString()));
    }
  }
  Future<void> loadMyVacancies(DataTar dataTar) async {
    emit(LoadingVacancy());
    try{
      var vacancies = await vacancyRepository.loadMyVacancies(dataTar);
      emit(VacancyLoaded(vacancies: vacancies));
    }catch(e){
      emit(VacancyLoadingFailed(error: e.toString()));
    }
  }

  Future<void> updateVacancy(Vacancy vacancy) async {
    emit(UpdatingVacancy());
    try{
      var result = await vacancyRepository.updateVacancy(vacancy);
      emit(VacancyUpdatedSuccessfully(message: result.message));
    }catch(e){
      emit(VacancyUpdatingFailed(error: e.toString()));
    }
  }
  Future<void> createVacancy(Vacancy vacancy) async {
    emit(CreatingVacancy());
    try{
      var create = await vacancyRepository.publishVacancy(vacancy);
      emit(VacancyCreatedSuccessfully(message: create.message));
    }catch(e){
      emit(VacancyCreatingFailed(error: e.toString()));
    }
  }

  Future<void> removeVacancy(Vacancy vacancy) async {
    emit(RemovingVacancy());
    try{
      var result = await vacancyRepository.removeVacancy(vacancy);
      emit(VacancyRemovedSuccessfully(message: result.message));
    }catch(e){
      emit(RemovingVacancyFailed(error: e.toString()));
    }
  }

}