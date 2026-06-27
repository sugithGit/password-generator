import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppRouterObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    log('New route pushed: ${route.settings.name}', name: 'AUTO ROUTE');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    log('Route popped: ${route.settings.name}', name: 'AUTO ROUTE');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    log('Tab route visited: ${route.name}', name: 'AUTO ROUTE');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    log('Tab route re-visited: ${route.name}', name: 'AUTO ROUTE');
  }
}
