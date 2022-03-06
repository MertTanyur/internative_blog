import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter/widgets.dart';
import 'package:internative_blog/screens/register.dart';
import 'package:internative_blog/state/user_controller.dart';
import 'package:internative_blog/widgets/blog_app_bar.dart';

import '../classes/user.dart';
import '../local_storage/storage.dart';
import '../state/auth_controller.dart';
import '../widgets/blog_nav_bar.dart';
import '../state/nav_bar_controller.dart';
import 'package:provider/provider.dart';
import '../views/blogs.dart';
import '../views/favorites.dart';
import '../views/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String id = 'mainScreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _widgetOptions = [
    const Favorites(),
    const Blogs(),
    const Profile(),
    // TextButton(
    //   child: Text(
    //     'Log out',
    //     style: TextStyle(fontSize: 30),
    //   ),
    //   key: const ValueKey(3),
    //   onPressed: () async {
    //     Box<Credentials> credBox = Hive.box<Credentials>('credentials');
    //     print('before ->>');
    //     print(credBox.values);
    //     await credBox.clear();
    //     print('after ->>');
    //     print(credBox.values);
    //   },
    // ),
  ];
  final List<Text> _appBarHeaders = const [
    Text(
      'My Favorites',
      key: ValueKey(0),
    ),
    Text(
      'Home',
      key: ValueKey(1),
    ),
    Text(
      'My Profile',
      key: ValueKey(2),
    ),

    // 'Article Detail',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<NavBarController>(
        builder: ((context, navBarController, _) => Scaffold(
              appBar: AppBar(
                  title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: _appBarHeaders[navBarController.currentIndex],
              )),
              body: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: _widgetOptions[navBarController.currentIndex]),
              bottomNavigationBar: CustomNavBar(size: size),
            )));
  }
}
