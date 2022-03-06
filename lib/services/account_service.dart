import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';

class AccountService {
  Future<Map> accountUpdate(
      String token, String image, String longtitude, String latitude) async {
    Map result;
    try {
      http.Response response = await http.post(
        Uri.parse(api_endpoint + 'Account/Update'),
        body: jsonEncode({
          "Image": image,
          "Location": {"Longtitude": longtitude, "Latitude": latitude}
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
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

  Future<Map> accountGet(String token) async {
    Map result;
    try {
      http.Response response = await http.get(
        Uri.parse(api_endpoint + 'Account/Get'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
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

  Future<Map> uploadImage(String token, File image) async {
    Map result;
    try {
      http.Response response = await http.post(
        Uri.parse(api_endpoint + 'Account/Update'),
        body: image,
        headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $token",
        },
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
}
