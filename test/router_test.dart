import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/routes/app_router.dart';

void main() {
  test('Instantiate AppRouter', () {
    final router = AppRouter();
    print(router.routes.map((e) => e.name).toList());
  });
}
