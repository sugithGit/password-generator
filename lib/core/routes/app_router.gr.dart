// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/cupertino.dart' as _i17;
import 'package:flutter/material.dart' as _i15;
import 'package:password_generator/features/auth/view/page/login_page.dart'
    as _i4;
import 'package:password_generator/features/gateway/view/page/biometric_gate_page.dart'
    as _i2;
import 'package:password_generator/features/gateway/view/page/master_key_page.dart'
    as _i5;
import 'package:password_generator/features/generate_password/view/page/password_generate_page.dart'
    as _i7;
import 'package:password_generator/features/onboarding/view/loading_page.dart'
    as _i3;
import 'package:password_generator/features/onboarding/view/onboarding_page.dart'
    as _i6;
import 'package:password_generator/features/onboarding/view/splash_page.dart'
    as _i9;
import 'package:password_generator/features/settings/view/page/settings_page.dart'
    as _i8;
import 'package:password_generator/features/vault/view/page/add_entry_page.dart'
    as _i1;
import 'package:password_generator/features/vault/view/page/vault_page.dart'
    as _i10;
import 'package:password_generator/features/vault/view/page/view_password_page.dart'
    as _i11;
import 'package:password_generator/service/password_manager/data/repositories/vault_repo_impl.dart'
    as _i16;
import 'package:password_generator/service/password_manager/domain/entities/vault_category.dart'
    as _i14;
import 'package:password_generator/service/password_manager/domain/entities/vault_entry.dart'
    as _i13;

/// generated route for
/// [_i1.AddEntryPage]
class AddEntryRoute extends _i12.PageRouteInfo<AddEntryRouteArgs> {
  AddEntryRoute({
    _i13.VaultEntry? existingEntry,
    _i14.VaultCategory? initialCategory,
    _i15.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         AddEntryRoute.name,
         args: AddEntryRouteArgs(
           existingEntry: existingEntry,
           initialCategory: initialCategory,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AddEntryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddEntryRouteArgs>(
        orElse: () => const AddEntryRouteArgs(),
      );
      return _i12.WrappedRoute(
        child: _i1.AddEntryPage(
          existingEntry: args.existingEntry,
          initialCategory: args.initialCategory,
          key: args.key,
        ),
      );
    },
  );
}

class AddEntryRouteArgs {
  const AddEntryRouteArgs({this.existingEntry, this.initialCategory, this.key});

  final _i13.VaultEntry? existingEntry;

  final _i14.VaultCategory? initialCategory;

  final _i15.Key? key;

  @override
  String toString() {
    return 'AddEntryRouteArgs{existingEntry: $existingEntry, initialCategory: $initialCategory, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddEntryRouteArgs) return false;
    return existingEntry == other.existingEntry &&
        initialCategory == other.initialCategory &&
        key == other.key;
  }

  @override
  int get hashCode =>
      existingEntry.hashCode ^ initialCategory.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i2.BiometricGatePage]
class BiometricGateRoute extends _i12.PageRouteInfo<void> {
  const BiometricGateRoute({List<_i12.PageRouteInfo>? children})
    : super(BiometricGateRoute.name, initialChildren: children);

  static const String name = 'BiometricGateRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.BiometricGatePage();
    },
  );
}

/// generated route for
/// [_i3.LoadingPage]
class LoadingRoute extends _i12.PageRouteInfo<void> {
  const LoadingRoute({List<_i12.PageRouteInfo>? children})
    : super(LoadingRoute.name, initialChildren: children);

  static const String name = 'LoadingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoadingPage();
    },
  );
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.MasterKeyPage]
class MasterKeyRoute extends _i12.PageRouteInfo<void> {
  const MasterKeyRoute({List<_i12.PageRouteInfo>? children})
    : super(MasterKeyRoute.name, initialChildren: children);

  static const String name = 'MasterKeyRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.MasterKeyPage();
    },
  );
}

/// generated route for
/// [_i6.OnboardingPage]
class OnboardingRoute extends _i12.PageRouteInfo<void> {
  const OnboardingRoute({List<_i12.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i7.PasswordGeneratePage]
class PasswordGenerateRoute extends _i12.PageRouteInfo<void> {
  const PasswordGenerateRoute({List<_i12.PageRouteInfo>? children})
    : super(PasswordGenerateRoute.name, initialChildren: children);

  static const String name = 'PasswordGenerateRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.PasswordGeneratePage();
    },
  );
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute({List<_i12.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsPage();
    },
  );
}

/// generated route for
/// [_i9.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashPage();
    },
  );
}

/// generated route for
/// [_i10.VaultPage]
class VaultRoute extends _i12.PageRouteInfo<VaultRouteArgs> {
  VaultRoute({
    required _i16.VaultRepoImpl repository,
    _i17.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         VaultRoute.name,
         args: VaultRouteArgs(repository: repository, key: key),
         initialChildren: children,
       );

  static const String name = 'VaultRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultRouteArgs>();
      return _i12.WrappedRoute(
        child: _i10.VaultPage(repository: args.repository, key: args.key),
      );
    },
  );
}

class VaultRouteArgs {
  const VaultRouteArgs({required this.repository, this.key});

  final _i16.VaultRepoImpl repository;

  final _i17.Key? key;

  @override
  String toString() {
    return 'VaultRouteArgs{repository: $repository, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VaultRouteArgs) return false;
    return repository == other.repository && key == other.key;
  }

  @override
  int get hashCode => repository.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i11.ViewPasswordPage]
class ViewPasswordRoute extends _i12.PageRouteInfo<ViewPasswordRouteArgs> {
  ViewPasswordRoute({
    required _i13.VaultEntry entry,
    _i15.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         ViewPasswordRoute.name,
         args: ViewPasswordRouteArgs(entry: entry, key: key),
         initialChildren: children,
       );

  static const String name = 'ViewPasswordRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewPasswordRouteArgs>();
      return _i11.ViewPasswordPage(entry: args.entry, key: args.key);
    },
  );
}

class ViewPasswordRouteArgs {
  const ViewPasswordRouteArgs({required this.entry, this.key});

  final _i13.VaultEntry entry;

  final _i15.Key? key;

  @override
  String toString() {
    return 'ViewPasswordRouteArgs{entry: $entry, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ViewPasswordRouteArgs) return false;
    return entry == other.entry && key == other.key;
  }

  @override
  int get hashCode => entry.hashCode ^ key.hashCode;
}
