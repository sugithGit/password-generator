import 'package:equatable/equatable.dart';

class Password with EquatableMixin {
  const Password({
    required this.password,
    required this.date,
  });

  final String password;
  final DateTime date;

  @override
  String toString() {
    return 'Password(password: $password, date: $date)';
  }

  @override
  List<Object?> get props => <Object?>[
        password,
        date,
      ];
}
