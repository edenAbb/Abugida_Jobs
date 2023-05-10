import 'package:et_job/models/job.dart';

import '../models/user.dart';

class SVacancies{
  Vacancies getVacancies(){
    List<Vacancy> vacancies = [];
    for(int x = 0; x < 5; x++){
      vacancies.add(sampleVacancy());
    }
    return Vacancies.fromVacancy(vacancies);
  }

  User sampleUser(){
    return  User(id: '000', fullName: 'winux',phoneNumber: '0922877115',
        role: UserRole.admin,education: "",environment: "",experience: "",
        jobType: "",category: "");
  }
  Vacancy sampleVacancy(){
    return  Vacancy(jobId: "hello",jobTitle: "Flutter Developer",
        jobDescription: "Remote flutter developer needed",
        jobType: JobType.permanent,
        jobEnvironment: JobEnvironment.remote,
        jobLocation: "Addis Ababa",
        qualification: Qualification.degree,
        experience: "0", endDate: "endDate",
        jobStatus: "open", jobCategory: JobCategory.programing, user: sampleUser());
  }
}