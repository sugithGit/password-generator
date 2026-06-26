import 'package:hive_ce/hive.dart';

import '../../domain/entities/password.dart';

class PasswordModel extends HiveObject {
  PasswordModel({
    required this.password,
    required this.date,
  });

  final String password;
  final DateTime date;

  @override
  String toString() {
    return 'Password(password: $password, date: $date)';
  }

  static PasswordModel fromPassword({required Password password}) {
    return PasswordModel(
      password: password.password,
      date: password.date,
    );
  }

  Password toPassword() {
    return Password(
      password: password,
      date: date,
    );
  }
}
