import 'package:et_job/models/user.dart';
import 'package:et_job/services/helper/header.dart';
import 'package:http/retry.dart';

class SUsers{
  Result login(String password){
    switch (password) {
      case 'admin0':
        return Result("200", true, "Success", UserRole.admin);
      case 'employer':
        return Result("200", true, "Success", UserRole.employer);
      case 'employee':
        return Result("200", true, "Success", UserRole.employee);
      default:
        return RequestResult()
            .requestResult("401","Invalid phone or password");
    }
  }
  Users getUsers(){
    List<User> users = [];
    for(int x = 0; x < 20; x++){
      users.add(sampleUser(x));
    }
    return Users.fromUser(users);
  }
  User sampleUser(int x){
    return  User(id: '000', fullName: 'tester',phoneNumber: '0922877115',
        role: x % 2  == 0 ? UserRole.admin : UserRole.employer ,education: "",environment: "",experience: "",
        jobType: "",category: "");
  }
  Result isPhoneRegistered(String phone){
    if(phone == "0922877115" || phone == "0922877116" ||
        phone == "0922877117"){
      return Result("200",true,"User Found",UserRole.guest);
    }else{
      return Result("404",false,"User Not Found",UserRole.guest);
    }
  }
}