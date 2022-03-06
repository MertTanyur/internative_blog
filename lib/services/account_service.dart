import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<Map> uploadImage(String token, XFile image) async {
    Map? result;
    try {
      print('image path is -> ${image.path}');
      var uri = Uri.parse(api_endpoint + 'General/UploadImage');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
          'accept': 'application/json'
        })
        ..files.add(await http.MultipartFile.fromPath('file', image.path,
            contentType: MediaType('image', 'png')));
      http.StreamedResponse response = await request.send();
      final responsed = await http.Response.fromStream(response);
      print(responsed.body);
      Map result = jsonDecode(responsed.body);
      return result;

      // if (response.statusCode == 200) print('Uploaded!');
      // http.StreamedResponse resp =
      // request.files.add(new http.MultipartFile.fromBytes(
      //     'file', await File.fromUri(Uri.parse(image.path)).readAsBytes(),
      //     contentType: new MediaType('image', 'jpeg')));

      // request.send().then((response) {
      //   if (response.statusCode == 200) print("Uploaded! $response");
      // });
      //   ..headers.addAll({'Authorization': 'Bearer $token'})
      //   // ..fields['file'] = bytes.toString()
      //   ..files.add(await http.MultipartFile.fromPath('file', image.path,
      //       contentType: MediaType('string', 'binary')));

      // http.StreamedResponse resp = await request.send();
      // final responsed = await http.Response.fromStream(resp);
      // print(responsed);
      // print(responsed.body);
      // // resp.stream.listen((value) => print(value));
      // // print('main response is -> ${jsonDecode(response.)})');
      // if (resp.statusCode == 200) {
      //   print('successful');
      //   result = resp.stream;
      // } else {
      //   print(resp.statusCode);
      //   // throw Exception('Failed to sign in');
      // }
    } catch (e) {
      print(e);
      return {'error': e};
    }
  }
}
