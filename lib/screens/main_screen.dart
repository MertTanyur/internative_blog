import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter/widgets.dart';
import 'package:internative_blog/widgets/blog_app_bar.dart';

import '../local_storage/storage.dart';
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
  final List<Widget> _widgetOptions = const [
    Text(
      'screen1',
      key: ValueKey(0),
    ),
    Blogs(),
    Text('screen3', key: ValueKey(3)),
  ];
  final List<String> _appBarHeaders = const [
    'My Favorites',
    'Home',
    'My Profile',
    'Article Detail',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<NavBarController>(
        builder: ((context, navBarController, _) => Scaffold(
              body: SizedBox(
                height: size.height,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: BlogAppBar(
                          key: ValueKey(navBarController.currentIndex),
                          title: _appBarHeaders[navBarController.currentIndex],
                          size: size),
                    ),
                    // Container(
                    //   height: size.height / 2,
                    //   child: AnimatedSwitcher(
                    //     duration: const Duration(seconds: 1),
                    //     child: _widgetOptions[navBarController.currentIndex],
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: _widgetOptions[navBarController.currentIndex]),
                    ),

                    // Text('welcome to main screen'),
                    // TextButton(
                    //   child: Text('print local storage'),
                    //   onPressed: () => print(
                    //     'local storage-> ${Hive.box<Credentials>('credentials').values.map((e) => e.creds).toList()}',
                    //   ),
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: CustomNavBar(size: size),

              //  BottomNavigationBar(
              //   iconSize: 32,
              //   showSelectedLabels: false,
              //   showUnselectedLabels: false,
              //   landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              //   items: const [
              //     BottomNavigationBarItem(
              //       label: 'Favorites',
              //       icon: Icon(Icons.favorite),
              //     ),
              //     BottomNavigationBarItem(
              //       label: 'Blogs',
              //       icon: Icon(Icons.home),
              //     ),
              //     BottomNavigationBarItem(
              //       label: 'Account',
              //       icon: Icon(Icons.person),
              //     )
              //   ],
              //   currentIndex: _selectedIndex,
              //   //       final List<String> _appBarHeaders = const [
              //   //   'Home',
              //   //   'My Favorites',
              //   //   'My Profile',
              //   //   'Article Detail',
              //   // ];
              //   onTap: (val) {
              //     setState(() {
              //       _selectedIndex = val;
              //     });
              //   },
              // ),
            )));
  }
}
