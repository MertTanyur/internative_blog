import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internative_blog/classes/user.dart';
import 'package:internative_blog/screens/register.dart';
import 'package:internative_blog/state/auth_controller.dart';
import 'package:provider/provider.dart';
import '../state/user_controller.dart';
import 'package:hive/hive.dart';
import '../local_storage/storage.dart';
import '../widgets/blog_app_bar.dart';
import 'login.dart';
import 'main_screen.dart';
import '../widgets/cred_input.dart';
import '../widget_generating_functions/widget_generator_functions.dart';

class Login extends StatefulWidget {
  static String id = 'login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _mailController;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _mailController = TextEditingController();
    _passwordController = TextEditingController();
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
                title: 'Login',
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
              //     title: Text('Login'),
              //   ),
              // ),

              FractionallySizedBox(
                widthFactor: 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_mailController.text != '' &&
                          _passwordController.text != '') {
                        var user = context.read<UserController>();
                        user.newUser(
                          User(
                            mail: _mailController.text,
                            password: _passwordController.text,
                          ),
                        );
                        Map response =
                            await context.read<AuthController>().signIn();
                        late String contentMessage;
                        bool redirect = false;
                        if (!response['HasError']) {
                          contentMessage = 'Logged in Successfully';
                          redirect = true;
                        } else if (response.containsKey('error')) {
                          contentMessage = 'Local Error\n ${response["error"]}';
                        } else {
                          contentMessage = response['Message'];
                          if (response.containsKey('ValidationErrors')) {
                            if (response['ValidationErrors'].length != 0) {
                              for (Map validationErrorMap
                                  in response['ValidationErrors']) {
                                contentMessage +=
                                    '\n' + validationErrorMap['Value'];
                              }
                            }

                            // contentMessage +=
                            //     '\n' + response['ValidationErrors'].map((val)=>val.value);
                          }
                        }
                        showSignError(context, 'Login Status:', contentMessage);
                        // clearRegistrationInputs();
                        FocusScope.of(context).unfocus();

                        if (redirect) {
                          Future.delayed(
                              const Duration(milliseconds: 1300),
                              () =>
                                  Navigator.pushNamed(context, MainScreen.id));
                        }
                      } else {
                        showSignError(context, 'Login Status:',
                            'Please fill email and password inputs');
                      }
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
                        Navigator.of(context).pushNamed(Register.id);
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

  void clearRegistrationInputs() {
    return setState(() {
      _mailController.clear();
      _passwordController.clear();
    });
  }
}
