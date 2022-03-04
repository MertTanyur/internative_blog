import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internative_blog/classes/user.dart';
import 'package:internative_blog/state/auth_controller.dart';
import 'package:provider/provider.dart';
import '../state/user_controller.dart';
import 'package:hive/hive.dart';
import '../local_storage/storage.dart';
import '../widgets/blog_app_bar.dart';
import 'login.dart';
import 'main_screen.dart';
import '../widgets/cred_input.dart';

class Register extends StatefulWidget {
  static String id = 'register';
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _mailController;
  late TextEditingController _passwordController;
  late TextEditingController _rePasswordController;
  @override
  void initState() {
    super.initState();
    _mailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlogAppBar(
                size: size,
                title: 'Register',
              ),
              Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 32),
                  width: size.width / 2,
                  height: size.width / 2,
                  decoration: BoxDecoration(
                      color: Color(0xffC4C9D2),
                      borderRadius: BorderRadius.circular(16)),
                  child: const FlutterLogo(
                    size: double.infinity,
                  ),
                ),
                CredInput(
                  inputController: _mailController,
                  icon: const Icon(Icons.mail),
                  label: 'mail',
                ),
                CredInput(
                    label: 'Password',
                    obscureText: true,
                    suffixIcon: const Icon(Icons.visibility_rounded),
                    suffixIcon2: const Icon(Icons.visibility_off_rounded),
                    icon: const Icon(Icons.lock),
                    inputController: _passwordController),
                CredInput(
                    label: 'Re-password',
                    icon: const Icon(Icons.lock),
                    obscureText: true,
                    suffixIcon: const Icon(Icons.visibility_rounded),
                    suffixIcon2: const Icon(Icons.visibility_off_rounded),
                    inputController: _rePasswordController),
                // TextButton(
                //   child: Text('print local storage'),
                //   onPressed: () => print(
                //     'local storage-> ${Hive.box<Credentials>('credentials').values}',
                //   ),
                // ),
              ]),

              // Theme(
              //   data: Theme.of(context).copyWith(
              //       listTileTheme: ListTileThemeData(
              //     tileColor: Color(0xff292F3B),
              //   )),
              //   child: ListTile(
              //     leading: Icon(Icons.login),
              //     title: Text('Register'),
              //   ),
              // ),

              FractionallySizedBox(
                widthFactor: 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_mailController.text != '' &&
                          _passwordController.text != '' &&
                          _rePasswordController.text != '') {
                        var user = context.read<UserController>();
                        user.newUser(User(
                            mail: _mailController.text,
                            password: _passwordController.text,
                            passwordRetry: _rePasswordController.text));
                        Map response =
                            await context.read<AuthController>().signUp();
                        late String contentMessage;
                        bool redirect = false;
                        if (!response['HasError']) {
                          contentMessage = 'Registered successfully';
                          redirect = true;
                        } else if (response.containsKey('error')) {
                          contentMessage = 'Local Error\n ${response["error"]}';
                        } else {
                          contentMessage = response['Message'];
                          if (response.containsKey('ValidationErrors')) {
                            for (Map validationErrorMap
                                in response['ValidationErrors']) {
                              contentMessage +=
                                  '\n' + validationErrorMap['Value'];
                            }
                            // contentMessage +=
                            //     '\n' + response['ValidationErrors'].map((val)=>val.value);
                          }
                        }
                        showDialog(
                          context: context,
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8),
                              actionsAlignment: MainAxisAlignment.center,
                              title: const Text('Registration status:'),
                              content: Text(contentMessage),
                              actions: [
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Ok');
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                        if (redirect) {
                          Future.delayed(
                              const Duration(milliseconds: 1300),
                              () =>
                                  Navigator.pushNamed(context, MainScreen.id));
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8),
                              actionsAlignment: MainAxisAlignment.center,
                              title: const Text('Registration status:'),
                              content: const Text(
                                  'please fill email and password inputs'),
                              actions: [
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context, 'Ok');
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.login_rounded),
                        Expanded(
                          child: Center(
                            child: Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              FractionallySizedBox(
                widthFactor: 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        elevation: 2,
                      ),
                      // style: ButtonStyle(

                      //     shadowColor: MaterialStateProperty.all(
                      //         Theme.of(context).colorScheme.primary)),
                      onPressed: () {
                        Navigator.of(context).pushNamed(Login.id);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.login_rounded),
                          Expanded(
                            child: Center(
                              child: Text('Login'),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              const Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}