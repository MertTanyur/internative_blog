import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class BlogService {
  Future<Map> getBlogs(String token) async {
    Map result;
    try {
      http.Response response = await http.post(
        Uri.parse(api_endpoint + 'Blog/GetBlogs'),
        body: jsonEncode({}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      // print('main response is -> ${jsonDecode(response.body)})');
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

  Future<Map> getCategories(String token) async {
    Map result;
    try {
      http.Response response = await http.get(
        Uri.parse(api_endpoint + 'Blog/GetCategories'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      // print('main response is -> ${jsonDecode(response.body)})');
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
    // print('service result is -> $result');
    return result;
  }

  Future<Map> toggleFavorite(String token, String blogId) async {
    Map result;
    try {
      http.Response response = await http.post(
        Uri.parse(api_endpoint + 'Blog/ToggleFavorite'),
        body: jsonEncode({"Id": blogId}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      // print('main response is -> ${jsonDecode(response.body)})');
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
