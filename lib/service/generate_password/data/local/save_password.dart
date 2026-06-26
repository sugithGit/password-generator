import 'package:hive_ce/hive.dart';

import '../../../../core/hive/hive_box_name.dart';
import '../model/password_model.dart';

class PasswordHistoryLocal {
  PasswordHistoryLocal() {
    _openBox();
  }
  late final Box<PasswordModel> _box;

  Future<void> _openBox() async {
    _box = await Hive.openBox(HiveBoxName.passwordHistory());
  }

  void savePassword({required PasswordModel password}) {
    _box.put(
      password.password,
      password,
    );
  }

  List<PasswordModel> getPasswordHistory() {
    return _box.values.toList();
  }

  void deletePassword() {
    _box.clear();
  }
}
