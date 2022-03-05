import 'package:flutter/cupertino.dart';

class NavBarController extends ChangeNotifier {
  int currentIndex = 1;
  void changeIndex(int val) {
    currentIndex = val;
    notifyListeners();
  }
}
