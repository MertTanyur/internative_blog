import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../state/auth_controller.dart';
import '../services/account_service.dart';
import '../services/blog_service.dart';

class AccountController extends ChangeNotifier {
  AccountController({this.authController});
  AuthController? authController;
  void updateAuthController(AuthController newAuthController) {
    authController = newAuthController;
    bearerToken = authController?.bearerToken;
    notifyListeners();
  }

  AccountService accountService = AccountService();
  BlogService blogService = BlogService();

  String? bearerToken;
  String? accountId;
  List favoriteBlogs = [];
  String? image;
  String? longtitude;
  String? latitude;
  XFile? imageFile;

  Stream? imageUploadStream;

  Map? rawBlogs;
  List? rawBlogList;

  Map<String, List<Map>>? processedBlogs;

  int selectedCategory = 0;

  void setCategory(int val) {
    selectedCategory = val;
    notifyListeners();
  }

  List? categories;

  Future<void> favBlog(String id) async {
    await toggleFavorite(id);
    favoriteBlogs.add(id);
    notifyListeners();
  }

  Future<void> unFavBlog(String id) async {
    await toggleFavorite(id);
    favoriteBlogs.remove(id);
    notifyListeners();
  }

  void setLocation(String long, String lat) {
    longtitude = long;
    latitude = lat;
    notifyListeners();
  }

  void setImageFile(XFile _imageFile) {
    try {
      imageFile = _imageFile;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void removeImageFile() {
    imageFile = null;
    notifyListeners();
  }

  void setImage(String val) {
    image = val;
    notifyListeners();
  }

// example account get response
//   {
//   "ValidationErrors": [],
//   "HasError": false,
//   "Message": null,
//   "Data": {
//     "Id": "621fc018b07d1e139af5b4d3",
//     "Email": "merttanyur@gmail.com",
//     "Image": null,
//     "Location": null,
//     "FavoriteBlogIds": []
//   }
// }
  Future<Map> accountGet() async {
    Map result = {};
    try {
      result = await accountService.accountGet(bearerToken!);
      if (!result['HasError']) {
        var ids = result['Data']['FavoriteBlogIds'] as List;
        var url = result['Data']['Image'] as String;
        ids.forEach((element) => favoriteBlogs.add(element));
        setImage(url);
      }
    } catch (e) {
      result['HasError'] = true;
      result['error'] = e;
    }
    return result;
  }

  Future<Map> accountUpdate() async {
    Map result = {};
    try {
      result = await accountService.accountUpdate(
          bearerToken!, image!, longtitude!, latitude!);
    } catch (e) {
      result['HasError'] = true;
      result['error'] = e;
    }
    return result;
  }

  Future<void> uploadImage() async {
    try {
      Map response = await accountService.uploadImage(bearerToken!, imageFile!);
      image = response['Data'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
    // imageUploadStream = result;
    // notifyListeners();
    // yield result;
  }

  // blog part
  Future<Map> toggleFavorite(String blogId) async {
    Map result = {};
    try {
      result = await blogService.toggleFavorite(bearerToken!, blogId);
    } catch (e) {
      result['HasError'] = true;
      result['error'] = e;
    }
    return result;
  }

  Future<void> getBlogs() async {
    Map result = {};
    try {
      result = await blogService.getBlogs(bearerToken!);
      rawBlogs = result;
      rawBlogList = rawBlogs!['Data'];
      notifyListeners();
      parseBlogs();
    } catch (e) {
      result['HasError'] = true;
      result['error'] = e;
      rawBlogs = result;
      notifyListeners();
    }
  }

  Future<void> parseBlogs() async {
    Map<String, List> result = {};

    List dataList = rawBlogs!['Data'];
    Map<String, List<Map>> classifyMap = {
      'Kategori 1': <Map>[],
      'Kategori 2': <Map>[],
      'Kategori 3': <Map>[],
      'Kategori 4': <Map>[],
    };
    try {
      for (Map data in dataList) {
        if (data.containsKey('Title')) {
          String text = data['Title'];
          classifyMap.forEach((key, value) =>
              text.contains(key) ? classifyMap[key]?.add(data) : () {});
          // print(classifyMap);
          processedBlogs = classifyMap;
          // processedBlogs!['Kategori 1']!.forEach((element) => print(element));
        }
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> getCategories() async {
    Map result = {};
    try {
      // print('get categories function is trigerred watch close! ');
      result = await blogService.getCategories(bearerToken!);
      categories = result['Data'];
      // print('result data -> ${result["Data"]}');
      // print('categories -> $categories');
      notifyListeners();
    } catch (e) {
      result['HasError'] = true;
      result['error'] = e;
      print(e);
    }
  }
}
