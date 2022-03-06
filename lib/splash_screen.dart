import 'package:flutter/material.dart';
import 'package:internative_blog/screens/main_screen.dart';
import 'package:rive/rive.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'state/user_controller.dart';
import 'state/auth_controller.dart';
import 'state/account_controller.dart';
import 'local_storage/storage.dart';
import 'classes/user.dart';
import 'screens/register.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      UserController userController = context.read<UserController>();
      AuthController authController = context.read<AuthController>();

      Box<Credentials> credBox = Hive.box<Credentials>('credentials');
      Credentials? credentials;
      User? oldUser;
      if (!credBox.isEmpty) {
        credentials = credBox.get(0);
        oldUser = credentials!.oldUser;
        userController.newUser(oldUser);
        authController.setBearerToken(credentials.token!);
        print(oldUser.signInCred);
        await context.read<AccountController>().getBlogs();
        var result = context.read<AccountController>().rawBlogs;
        if (result != null) {
          if (result.containsKey('HasError') && !result['HasError']) {
            await context.read<AccountController>().accountGet();

            Navigator.pushReplacementNamed(context, MainScreen.id);
          } else {
            print(result['HasError']);
            if (result.containsKey('Message')) {
              // request type error for blog fetching
              print(result['Message']);
            } else {
              // local error for blog fetching
              print(result['error']);
            }
          }
        }
      } else {
        Navigator.pushNamed(context, Register.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText(
                      'InterNative Blog',
                      entryEnd: 0.4,
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    WavyAnimatedText(
                      'Fetching Data',
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        RiveAnimation.asset('assets/inter_native_animation.riv'),
      ]),
    );
  }
}
