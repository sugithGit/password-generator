part of 'gateway_controller.dart';

class _GatewayState extends GetxState {
  final RxBool _isAuthenticating = false.obs;
  final RxBool _authFailed = false.obs;

  bool get isAuthenticating => _isAuthenticating.value;
  bool get authFailed => _authFailed.value;

  @override
  void onClose() {
    _isAuthenticating.close();
    _authFailed.close();
  }
}
