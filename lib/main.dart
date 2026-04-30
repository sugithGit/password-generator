import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'app_view.dart';
import 'core/hive/hive_registrar.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapters();
  runApp(const MyApp());
}
