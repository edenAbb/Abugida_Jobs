
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
      //var vacancies = await vacancyRepository.loadVacancies(dataTar);
      var vacancies = await vacancyRepository.fakeVacancies(dataTar);
      emit(VacancyLoaded(vacancies: vacancies));
    }catch(e){
      emit(VacancyLoadingFailed(error: e.toString()));
    }
  }
  Future<void> loadMyVacancies(DataTar dataTar) async {
    emit(LoadingVacancy());
    try{
      //var vacancies = await vacancyRepository.loadMyVacancies(dataTar);
      var vacancies = await vacancyRepository.myFakeVacancies(dataTar);
      emit(VacancyLoaded(vacancies: vacancies));
    }catch(e){
      emit(VacancyLoadingFailed(error: e.toString()));
    }
  }

  Future<void> searchVacancy(DataTar dataTar, String query) async {
    emit(LoadingVacancy());
    try{
      //var vacancies = await vacancyRepository.loadMyVacancies(dataTar);
      var vacancies = await vacancyRepository.fakeSearch(dataTar,query);
      emit(VacancyLoaded(vacancies: vacancies));
    }catch(e){
      emit(VacancyLoadingFailed(error: e.toString()));
    }
  }
  Future<void> updateVacancy(Vacancy vacancy, int target) async {
    emit(UpdatingVacancy());
    try{
      var result = await vacancyRepository.updateVacancy(vacancy,target);
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


  Future<void> applyVacancy(Vacancy vacancy) async {
    emit(ApplyingVacancy());
    try{
      var result = await vacancyRepository.applyForJob(vacancy);
      emit(AppliedSuccessfully(message: result.message));
    }catch(e){
      emit(ApplyingVacancyFailed(error: e.toString()));
    }
  }
  Future<void> acceptVacancy(Vacancy vacancy) async {
    emit(AcceptingVacancy());
    try{
      var result = await vacancyRepository.acceptRequest(vacancy);
      emit(AcceptedSuccessfully(message: result.message));
    }catch(e){
      emit(AcceptingVacancyFailed(error: e.toString()));
    }
  }
  Future<void> cancelVacancy(Vacancy vacancy) async {
    emit(CancelingVacancy());
    try{
      var result = await vacancyRepository.cancelProgress(vacancy);
      emit(CanceledSuccessfully(message: result.message));
    }catch(e){
      emit(CancelingVacancyFailed(error: e.toString()));
    }
  }
  Future<void> completeVacancy(Vacancy vacancy) async {
    emit(CompletingVacancy());
    try{
      var result = await vacancyRepository.completeJob(vacancy);
      emit(CompletedSuccessfully(message: result.message));
    }catch(e){
      emit(CompletingVacancyFailed(error: e.toString()));
    }
  }

}