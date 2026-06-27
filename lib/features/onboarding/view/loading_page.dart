import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../generate_password/view/widgets/header.dart';

@RoutePage()
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AppLogo()));
  }
}
