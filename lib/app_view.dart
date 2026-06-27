import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import 'core/theme/shadcn_theme.dart';
import 'core/services/auth_service.dart';
import 'core/services/encryption_service.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/generate_password/view/page/password_generate_page.dart';
import 'firebase_options.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> intialization = Firebase.initializeApp(
      options: firebaseOptions,
    );

    final EncryptionService encryptionService = EncryptionService(
      sodium: sodiumInstance,
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
          return BlocProvider<AuthBloc>(
            create: (_) =>
                AuthBloc(authService: AuthService())..add(AuthCheckRequested()),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Password Manager',
              theme: ShadcnTheme.darkTheme,
              darkTheme: ShadcnTheme.darkTheme,
              themeMode: ThemeMode.dark,
              home: PasswordGeneratePage(
                encryptionService: encryptionService,
              ),
            ),
          );
        },
      ),
    );
  }
}
