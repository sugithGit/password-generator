import 'package:hive_ce/hive.dart';

import 'hive_box_name.dart';

class UserPrefsLocal {
  UserPrefsLocal();

  Future<Box<dynamic>> get _box async {
    final String boxName = HiveBoxName.userPrefs();
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return Hive.openBox(boxName);
  }

  Future<void> saveUseUnlock({required bool useUnlock}) async {
    final Box<dynamic> box = await _box;
    await box.put('useUnlock', useUnlock);
  }

  Future<bool> getUseUnlock() async {
    final Box<dynamic> box = await _box;
    return box.get('useUnlock', defaultValue: false) as bool;
  }
}
