import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class EmptySliver extends StatelessWidget {
  const EmptySliver({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter();
  }
}
