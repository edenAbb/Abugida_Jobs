import 'dart:math';

import 'user.dart';

class Vacancy {
  String jobId;
  String jobTitle;
  String jobDescription;
  JobType jobType; // permanent(full time) or contractual
  JobEnvironment jobEnvironment; //office or remote
  String jobLocation;
  Qualification qualification;
  String experience;
  String endDate;
  String jobStatus; // open, closed, ongoing, completed, archived
  JobCategory jobCategory; // Programing or Graphics Designing
  User? user;
  Vacancy(
      {required this.jobId,
      required this.jobTitle,
      required this.jobDescription,
      required this.jobType,
      required this.jobEnvironment,
      required this.jobLocation,
      required this.qualification,
      required this.experience,
      required this.endDate,
      required this.jobStatus,
      required this.jobCategory,
      this.user});
  factory Vacancy.fromJson(Map<String, dynamic> json) {
    return Vacancy(
        jobId: json.containsKey('id') ? json["id"].toString() : "",
        jobTitle: json.containsKey('title') ? json["title"] : "",
        jobDescription: json.containsKey('description') ? json["description"] : "",
        jobType: json.containsKey('type') ? jTypeFromString(json["type"]) : JobType.permanent,
        jobEnvironment: json.containsKey('environment') ? jEnvFromString(json["environment"]) : JobEnvironment.remote,
        jobLocation: json.containsKey('location') ? json["location"] : "",
        qualification: json.containsKey('qualification') ? jQuaFromString(json['qualification']) : Qualification.degree,
        experience: json.containsKey('experience') ? json['experience'] : "0",
        endDate: json.containsKey('end_date') ? json['end_date'] : "",
        jobStatus: json.containsKey('status') ? json['status'] : "",
        jobCategory: json.containsKey('category') ? jCatFromString(json['category']) : JobCategory.programing,
        //user: json.containsKey('owner') ? User.fromJson(json['owner']) : null
        //user: json.containsKey('owner') ?json['owner'] : null
    );
  }
  @override
  String toString() => 'Vacancy {'
      'id: $jobId,'
      'jobTitle: $jobTitle,'
      'jobDescription: $jobDescription,'
      'jobType: $jobType,'
      'jobEnvironment: $jobEnvironment,'
      'jobLocation: $jobLocation,'
      'qualification: $qualification,'
      'experience: $experience),'
      'endDate: $endDate,'
      'jobStatus: $jobStatus,'
      'jobCategory: $jobCategory,'
      'user: $user,'
      '}';
}
class Vacancies{
  List<Vacancy> vacancies = [];
  Vacancies.fromJson(List<dynamic> parsedJson) {
    vacancies = parsedJson.map((i) => Vacancy.fromJson(i)).toList();
  }
  Vacancies.fromVacancy(this.vacancies);

}
enum JobCategory { programing, graphics }

enum Qualification { masters, degree, diploma, any }

enum JobType { permanent, contract }

enum JobEnvironment { inOffice, remote }


JobType jTypeFromString(String type){
  switch(type){
    case 'Permanent': return JobType.permanent;
    case 'Contract': return JobType.contract;
    default: return JobType.permanent;
  }
}
String jTypeFromType(JobType type){
  switch(type){
    case JobType.permanent: return "Permanent";
    case JobType.contract: return "Contract";
    default: return "Permanent";
  }
}

JobEnvironment jEnvFromString(String env){
  switch(env){
    case 'InOffice': return JobEnvironment.inOffice;
    case 'Remote': return JobEnvironment.remote;
    default: return JobEnvironment.remote;
  }
}
String jEnvFromEnv(JobEnvironment env){
  switch(env){
    case JobEnvironment.inOffice: return "InOffice";
    case JobEnvironment.remote: return "Remote";
    default: return "Remote";
  }
}

JobCategory jCatFromString(String env){
  switch(env){
    case 'Programing': return JobCategory.programing;
    case 'Graphics': return JobCategory.graphics;
    default: return JobCategory.programing;
  }
}
String jCatFromCat(JobCategory cat){
  switch(cat){
    case JobCategory.programing: return "Programing";
    case JobCategory.graphics: return "Graphics";
    default: return "Programing";
  }
}

Qualification jQuaFromString(String qua){
  switch(qua){
    case 'Masters': return Qualification.masters;
    case 'Degree': return Qualification.degree;
    case 'Diploma': return Qualification.diploma;
    case 'Any': return Qualification.any;
    default: return Qualification.degree;
  }
}
String jQuaFromQua(Qualification qua){
  switch(qua){
    case Qualification.masters: return "Masters";
    case Qualification.degree: return "Degree";
    case Qualification.diploma: return "Diploma";
    case Qualification.any: return "Any";
    default: return "Degree";
  }
}



