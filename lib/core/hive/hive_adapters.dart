import 'package:hive_ce/hive.dart';

import '../../service/generate_password/data/model/password_model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters(<AdapterSpec<dynamic>>[AdapterSpec<PasswordModel>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}
