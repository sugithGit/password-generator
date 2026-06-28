import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sodium/sodium.dart';

import 'app_view.dart';
import 'core/db/hive/hive_registrar.g.dart';

late final Sodium sodiumInstance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapters();

  // Initialize Sodium
  sodiumInstance = await SodiumInit.init();

  runApp(const MyApp());
}
