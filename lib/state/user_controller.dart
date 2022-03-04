import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../classes/user.dart';

class UserController extends ChangeNotifier {
  // bool? isUserLoggedIn;
  User? user;
  void newUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  Map get signUpCred => {
        "Email": user!.mail,
        "Password": user!.password,
        "PasswordRetry": user!.password
      };
}
