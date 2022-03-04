import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../state/auth_controller.dart';
import '../config.dart';

class AuthService {
  // example signIn response
  //   {
  //   "ValidationErrors": [],
  //   "HasError": false,
  //   "Message": null,
  //   "Data": {
  //     "Token": "xxxxxxxxx"
  //   }
  // }
  Future<Map> signIn(Map signInCred) async {
    Map result;
    print('main parameter is -> $signInCred');
    print(jsonEncode(signInCred));
    try {
      http.Response response = await http.post(
        Uri.parse(api_endpoint + 'Login/SignIn'),
        body: jsonEncode(signInCred),
        headers: {"Content-Type": "application/json"},
      );
      print('main response is -> ${jsonDecode(response.body)})');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      } else {
        result = {
          'HasError': true,
          'error': response.statusCode,
        };
        // throw Exception('Failed to sign in');
      }
    } catch (e) {
      result = {
        'HasError': true,
        'error': 'local error',
      };
      print(e);
    }

    return result;
  }

  Future<Map> signUp(Map signUpCred) async {
    Map result;
    print('signUpCred is -> $signUpCred');
    print('uri is -> ${api_endpoint + 'Login/SignUp'}');
    http.Response response = await http.post(
        Uri.parse(api_endpoint + 'Login/SignUp'),
        body: jsonEncode(signUpCred),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      print(result);
      result.values.forEach((element) {
        print(element.runtimeType);
      });
    } else {
      result = {'status': response.statusCode, 'HasError': true};
      print(result);

      // throw Exception('Failed to sign up');
    }
    return result;
  }
}
