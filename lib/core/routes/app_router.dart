import 'package:auto_route/auto_route.dart';

import 'app_route_enum.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRouteGuard> get guards => <AutoRouteGuard>[];

  @override
  List<AutoRoute> get routes => _routeList();

  List<AutoRoute> _routeList() {
    return AppRouteEnum.values.map<AutoRoute>(_route).toList();
  }

  AutoRoute _route(AppRouteEnum route) {
    return switch (route) {
      AppRouteEnum.splash => AutoRoute(
        path: AppRouteEnum.splash.path,
        page: SplashRoute.page,
        initial: true,
      ),
      AppRouteEnum.loading => AutoRoute(
        path: AppRouteEnum.loading.path,
        page: LoadingRoute.page,
      ),
      AppRouteEnum.login => AutoRoute(
        path: AppRouteEnum.login.path,
        page: LoginRoute.page,
      ),
      AppRouteEnum.masterKey => AutoRoute(
        path: AppRouteEnum.masterKey.path,
        page: MasterKeyRoute.page,
      ),
      AppRouteEnum.vault => AutoRoute(
        path: AppRouteEnum.vault.path,
        page: VaultRoute.page,
      ),
      AppRouteEnum.biometricGate => AutoRoute(
        path: AppRouteEnum.biometricGate.path,
        page: BiometricGateRoute.page,
      ),
      AppRouteEnum.addEntry => AutoRoute(
        path: AppRouteEnum.addEntry.path,
        page: AddEntryRoute.page,
      ),
      AppRouteEnum.viewPassword => AutoRoute(
        path: AppRouteEnum.viewPassword.path,
        page: ViewPasswordRoute.page,
      ),
      AppRouteEnum.passwordGenerate => AutoRoute(
        path: AppRouteEnum.passwordGenerate.path,
        page: PasswordGenerateRoute.page,
      ),
      AppRouteEnum.onboarding => AutoRoute(
        path: AppRouteEnum.onboarding.path,
        page: OnboardingRoute.page,
      ),
    };
  }
}
