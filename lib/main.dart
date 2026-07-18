import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sodium/sodium_sumo.dart';

import 'app_view.dart';
import 'core/db/hive/hive_registrar.g.dart';
import 'firebase_options.dart';

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

  await Firebase.initializeApp(options: firebaseOptions);
  await GoogleSignIn.instance.initialize();

  runApp(const MyApp());
}
