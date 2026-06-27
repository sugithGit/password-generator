import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';
import 'package:toastification/toastification.dart';

import 'core/theme/shadcn_theme.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/generate_password/view/page/password_generate_page.dart';
import 'firebase_options.dart';
import 'main.dart';

import 'service/auth/data/local/encryption_local.dart';
import 'service/auth/data/remote/firebase_auth_remote.dart';
import 'service/auth/data/repositories/auth_repo_impl.dart';
import 'service/auth/data/repositories/encryption_repo_impl.dart';
import 'service/auth/domain/repositories/encryption_repo.dart';
import 'service/auth/domain/use_cases/get_current_user_use_case.dart';
import 'service/auth/domain/use_cases/sign_in_use_case.dart';
import 'service/auth/domain/use_cases/sign_out_use_case.dart';
import 'service/auth/domain/use_cases/sign_up_use_case.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> intialization = Firebase.initializeApp(
      options: firebaseOptions,
    );

    final EncryptionLocal encryptionLocal =
        EncryptionLocal(sodium: sodiumInstance);
    final EncryptionRepo encryptionRepo = EncryptionRepoImpl(
      encryptionLocal: encryptionLocal,
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
          return GetInWidget(
            dependencies: <GetIn<dynamic>>[
              GetIn<AuthController>(() {
                final FirebaseAuthRemote authRemote = FirebaseAuthRemote();
                final AuthRepoImpl authRepo =
                    AuthRepoImpl(firebaseAuthRemote: authRemote);
                return AuthController(
                  getCurrentUserUseCase: GetCurrentUserUseCase(authRepo),
                  signInUseCase: SignInUseCase(authRepo),
                  signUpUseCase: SignUpUseCase(authRepo),
                  signOutUseCase: SignOutUseCase(authRepo),
                )..checkAuth();
              }),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Password Manager',
              theme: ShadcnTheme.darkTheme,
              darkTheme: ShadcnTheme.darkTheme,
              themeMode: ThemeMode.dark,
              home: PasswordGeneratePage(
                encryptionRepo: encryptionRepo,
              ),
            ),
          );
        },
      ),
    );
  }
}
