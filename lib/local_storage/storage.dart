import 'package:internative_blog/classes/user.dart';
import 'package:hive/hive.dart';
part 'storage.g.dart';

@HiveType(typeId: 1)
class Credentials extends User {
  Credentials({this.token, mail, password})
      : super(mail: mail, password: password);

  @HiveField(0)
  String? token;

  Map get creds => {
        'mail': super.mail,
        'password': super.password,
        'token': token,
      };
  User get oldUser => User.fromCredsMap(creds);
}
