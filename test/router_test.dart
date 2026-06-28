import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/routes/app_router.dart';

void main() {
  test('Instantiate AppRouter', () {
    final router = AppRouter();
    if (kDebugMode) {
      print(router.routes.map((e) => e.name).toList());
    }
  });
}
