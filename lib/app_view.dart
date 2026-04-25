import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import 'core/const/constants.dart';
import 'features/generate_password/presentation/page/password_generate_page.dart';
import 'features/onboarding/presentation/loading_page.dart';
import 'firebase_options.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _intialization = Firebase.initializeApp(
    options: firebaseOptions,
  );
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: FutureBuilder<FirebaseApp>(
        future: _intialization,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              log('Error: ${snapshot.error}');
            }
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Password Generator',
              theme: ThemeData(
                scaffoldBackgroundColor: scaffoldColor,
                primaryColor: scaffoldColor,
                fontFamily: GoogleFonts.poppins().fontFamily,
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.white),
                ),
              ),
              home: const PasswordGeneratePage(),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
            ),
            home: const LoadingPage(),
          );
        },
      ),
    );
  }
}
