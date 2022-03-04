import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../state/user_controller.dart';
import 'package:hive/hive.dart';
import '../local_storage/storage.dart';

final authService = AuthService();

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  AuthController({this.userController}) {
    _logInStreamController.sink.add(_isLoggedIn);
  }
  UserController? userController;

  void updateUserController(UserController updatedUserController) {
    userController = updatedUserController;
  }

  String? bearerToken;

  Future<Map> signIn() async {
    Map response = {};
    try {
      response = await authService.signIn(userController!.user!.signInCred);
      if (!response['HasError']) {
        bearerToken = response['Data']['Token'];
        authSuccessful();
      }
    } catch (e) {
      print(e);
      response['error'] = e;
      response['HasError'] = true;
    }
    print('response is -> $response');
    return response;
    // print('sign up response is -> $response');
  }

  Future<Map> signUp() async {
    Map response = {};
    try {
      response = await authService.signUp(userController!.user!.signUpCred);
      if (!response['HasError']) {
        bearerToken = response['Data']['Token'];
        authSuccessful();
      }
    } catch (e) {
      print(e);
      response['error'] = e;
      response['HasError'] = true;
    }
    print('response is -> $response');
    return response;
  }

  void authSuccessful() {
    print('auth. successful');
    _isLoggedIn = true;
    _logInStreamController.sink.add(_isLoggedIn);
    saveCredsToStorage();
  }

  void logOut() {
    _isLoggedIn = false;
    _logInStreamController.sink.add(_isLoggedIn);
  }

  Future<void> checkAuthentication() async {
    //
  }

  final _logInStreamController = StreamController<bool>();

  Stream<bool>? get stream => _logInStreamController.stream;

  // local storage functions
  void saveCredsToStorage() {
    var box = Hive.box<Credentials>('credentials');
    box.add(Credentials(
        token: bearerToken,
        mail: userController!.user!.mail,
        password: userController!.user!.password));
  }
}