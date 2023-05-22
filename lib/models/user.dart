import 'package:et_job/utils/env/session.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';


class User {
  String id;
  String fullName;
  String? email;
  String phoneNumber;
  String? gender;
  String? profileImage;
  String? cvAsPdf;
  String? token;
  UserRole role;
  String education;
  String jobType;
  String environment;
  String category;
  String experience;
  User(
      {required this.id,
        required this.fullName,
        this.email,
        required this.phoneNumber,
        this.gender,
        this.profileImage,
        this.cvAsPdf,
        this.token,
        required this.role,
        required this.education,
        required this.jobType,
        required this.environment,
        required this.category,
        required this.experience
      });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json.containsKey('id') ? json["id"].toString() : "",
        fullName: json.containsKey('fullname') ? json["fullname"] : "",
        email: json.containsKey('email') ? json["email"] : "",
        gender: json.containsKey('gender') ? json["gender"] : "",
        phoneNumber: json.containsKey('phone') ? json["phone"] : "",
        profileImage: json.containsKey('profile_image') ? json["profile_image"] : "",
        cvAsPdf: json.containsKey('cv_as_pdf') ? json['cv_as_pdf'] : "",
        token: json.containsKey('token') ? json['token'] : "",
        role: json.containsKey('role') ? getRole(json['role']) : UserRole.guest,
        education: json.containsKey('education') ? json['education'] : "Unavailable",
        jobType: json.containsKey('jobType') ? json['jobType'] : "Unavailable",
        environment: json.containsKey('environment') ? json['environment'] : "Unavailable",
        category: json.containsKey('category') ? json['category'] : "Unavailable",
        experience: json.containsKey('experience') ? json['experience'] : "0");
  }

  factory User.fromStorage(Map<String, dynamic> storage) {
    return User(
        id: storage.containsKey('id') ? storage["id"] : "",
        fullName: storage.containsKey('full_name') ? storage["full_name"] : "",
        email: storage.containsKey('email') ? storage["email"] : "",
        gender: storage.containsKey('gender') ? storage["gender"] : "",
        phoneNumber: storage.containsKey('phone') ? storage["phone"] : "",
        profileImage: storage.containsKey('profile_image') ? storage["profile_image"] : "",
        cvAsPdf: storage.containsKey('cv_as_pdf') ? storage['cv_as_pdf'] : "",
        token: storage.containsKey('token') ? storage['token'] : "",
        role: storage.containsKey('role') ? getRole(storage['role']) : UserRole.guest,
        education: storage.containsKey('education') ? storage['education'] :  "Unavailable",
        jobType: storage.containsKey('job_type') ? storage['job_type'] :  "Unavailable",
        environment: storage.containsKey('environment') ? storage['environment'] :  "Unavailable",
        category: storage.containsKey('category') ? storage['category'] : "Unavailable",
        experience: storage.containsKey('experience') ? storage['experience'] : "0");
  }

  @override
  String toString() => 'User {Id: $id }';
}
enum UserRole{
  admin, employer, employee, moderator, guest
}
UserRole getRole(String role) {
  Session().logSession("user-role", role);
  switch (role) {
    case 'admin':
      return UserRole.admin;
    case 'employer':
      return UserRole.employer;
    case 'employee':
      return UserRole.employee;
    case 'guest':
      return UserRole.guest;
    default:
      return UserRole.guest;
  }
}
class Users{
  List<User> users = [];
  Users.fromJson(List<dynamic> parsedJson) {
    users = parsedJson.map((i) => User.fromJson(i)).toList();
  }
  Users.fromUser(this.users);
}
