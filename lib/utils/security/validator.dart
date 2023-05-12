class DataValidator{
  String validateEmail(String email) {
    // 1
    RegExp regex = RegExp(r'\w+@\w+\.\w+'); // translates to word@word.word
    // 2
    if (email.isEmpty) {
      return 'We need an email address';
    } else if (!regex.hasMatch(email)) {
      return "That doesn't look like an email address";
    } else {
      return "0";
    }
  }

}
class Sanitizer{
  String? isFullNameValid(String name){
    if(name.isEmpty){
      return 'Please enter Full name';
    }else if(!name.contains(" ")){
      return "Please input Full name";
    }else if(name.length < 5){
      return "Please use valid name";
    }else if(!RegExp(r'^[a-z]+$').hasMatch(name.split(' ')[0])){
      return "Please use only letters";
    }else if(!RegExp(r'^[a-z]+$').hasMatch(name.split(' ')[1])){
      return "Please use only letters";
    }
    return null;
  }
  String? isPhoneValid(String phone){
    if(phone.isEmpty){
      return "Phone number required";
    }else if(phone.length < 10){
      return "Phone number length must not be less than 10";
    }else if(!phone.startsWith("09")){
      return "Invalid phone format! use 09... format";
    }
    return null;
  }
  bool _validEmail(String email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
  String? isExpValid(int year){
    if(year > 0){
      return null;
    }
    return "Please input valid data";
  }
  String? isEmailValid(String email){
    if(email.isEmpty){
      return 'Please enter Your Email';
    }else if(!_validEmail(email)){
      return 'Please use valid email';
    }
    return null;
  }
  String? isPasswordValid(String password){
    if(password.isEmpty){
      return 'Please enter Your Password';
    }else if(password.length < 6){
      return 'Password length must not be less than 6';
    }else if(password.length > 25){
      return 'Password length must not be greater than 25';
    }
    return null;
  }
  String? isPasswordMatch(String password1 , String password2){
     if(isPasswordValid(password1) == null &&
        isPasswordValid(password2) == null && password1 == password2){
       return null;
     }else if(password2.isEmpty){
       return 'Please confirm Your Password';
     }else if(password2.length < 6){
       return 'Password length must not be less than 6';
     }
     return "Password Didn't match";
  }
  String? isVerificationCodeValid(String code){
    if(code.isEmpty){
      return "Please insert code";
    }else if(code.length < 6){
      return "Code length must not be less than 6";
    }
    return null;
  }
  String? isBankAccountValid(String code){
    if(code.isEmpty){
      return "Please insert account number";
    }else if(code.length < 10){
      return "account number length must not be less than 10 digit";
    }
    return null;
  }
  String? canWithdraw(String balance, String amount){
    if(amount.isEmpty){
      return "Please insert amount";
    }
    double bal = double.parse(balance);
    double amn = double.parse(amount);
    return amn < bal + 100 ? null
        : "Your balance is insufficient, please recharge";
  }


  String? is3Length(String code){
    if(code.isEmpty){
      return "Please insert data";
    }else if(code.length < 3){
      return "length must not be less than 3";
    }
    return null;
  }


}