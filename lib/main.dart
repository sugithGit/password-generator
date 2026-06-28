import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sodium/sodium_sumo.dart';

import 'app_view.dart';
import 'core/db/hive/hive_registrar.g.dart';

late final SodiumSumo sodiumInstance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapters();

  // Initialize Sodium
  sodiumInstance = await SodiumSumoInit.init();

  runApp(const MyApp());
}
