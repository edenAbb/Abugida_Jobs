import 'package:et_job/models/job.dart';

import '../models/user.dart';

class SVacancies{
  Vacancies getVacancies(){
    List<Vacancy> vacancies = [];
    for(int x = 0; x < 15; x++){
      if(x % 2 == 0){
        vacancies.add(sampleVacancyJava());
      }
      else if(x % 3 == 0){
        vacancies.add(sampleVacancyFlutter());
      }
      else{
        vacancies.add(sampleVacancyPython());
      }

    }
    return Vacancies.fromVacancy(vacancies);
  }

  User sampleUser(){
    return  User(id: '000', fullName: 'winux',phoneNumber: '0922877115',
        role: UserRole.admin,education: "",environment: "",experience: "",
        jobType: "",category: "");
  }



  Vacancies searchVacancies(String query){
    List<Vacancy> vacancies = [];
    for(int x = 0; x < 5; x++){
      if(query.contains('flu')){
        vacancies.add(sampleVacancyFlutter());
      }
      if(query.contains('jav')){
        vacancies.add(sampleVacancyJava());
      }
      if(query.contains('pyt')){
        vacancies.add(sampleVacancyPython());
      }
    }
    return Vacancies.fromVacancy(vacancies);
  }



  Vacancy sampleVacancyFlutter(){
    return  Vacancy(jobId: "hello",jobTitle: "Flutter Developer",
        jobDescription: "Remote flutter developer needed",
        jobType: JobType.permanent,
        jobEnvironment: JobEnvironment.remote,
        jobLocation: "Addis Ababa",
        qualification: Qualification.degree,
        experience: "0", endDate: "endDate",
        jobStatus: "open", jobCategory: JobCategory.programing, user: sampleUser());
  }
  Vacancy sampleVacancyJava(){
    return  Vacancy(jobId: "hello",jobTitle: "Java Developer",
        jobDescription: "Java developer needed",
        jobType: JobType.permanent,
        jobEnvironment: JobEnvironment.remote,
        jobLocation: "Addis Ababa",
        qualification: Qualification.degree,
        experience: "0", endDate: "endDate",
        jobStatus: "open", jobCategory: JobCategory.programing, user: sampleUser());
  }
  Vacancy sampleVacancyPython(){
    return  Vacancy(jobId: "hello",jobTitle: "Python Developer",
        jobDescription:  "Python developer needed",
        jobType: JobType.permanent,
        jobEnvironment: JobEnvironment.remote,
        jobLocation: "Addis Ababa",
        qualification: Qualification.degree,
        experience: "0", endDate: "endDate",
        jobStatus: "open", jobCategory: JobCategory.programing, user: sampleUser());
  }

}