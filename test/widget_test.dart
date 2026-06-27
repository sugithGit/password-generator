import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:password_generator/app_view.dart';
import 'package:password_generator/main.dart';
import 'package:sodium/sodium.dart';

void main() {
  setUpAll(() async {
    final Directory tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    sodiumInstance = await SodiumInit.init();
  });

  testWidgets('Password Generator UI loads successfully',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the password settings and creation text are present on screen.
    expect(find.text('PASSWORD SETTINGS'), findsOneWidget);
    expect(find.text('CREATE RANDOM PASSWORD'), findsOneWidget);
  });
}
