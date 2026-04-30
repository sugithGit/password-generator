import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import 'core/const/constants.dart';
import 'features/generate_password/presentation/page/password_generate_page.dart';
import 'firebase_options.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> intialization = Firebase.initializeApp(
      options: firebaseOptions,
    );
    return ToastificationWrapper(
      child: FutureBuilder<FirebaseApp>(
        future: intialization,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              log('Error: ${snapshot.error}');
            }
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Password Generator',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: scaffoldColor,
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.monaSans().fontFamily,
                ),
              ),
            ),
            home: const PasswordGeneratePage(),
          );
        },
      ),
    );
  }
}
