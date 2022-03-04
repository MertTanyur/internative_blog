import 'package:hive/hive.dart';

class User {
  User({this.mail, this.password, this.passwordRetry});
  @HiveField(1)
  String? mail;
  @HiveField(2)
  String? password;

  String? passwordRetry;

  Map get signInCred => {'Email': mail, 'Password': password};
  Map get signUpCred =>
      {'Email': mail, 'Password': password, 'PasswordRetry': passwordRetry};
}
