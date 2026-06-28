part of 'gateway_controller.dart';

class _GatewayState extends GetxState {
  final RxBool _isAuthenticating = false.obs;
  final RxBool _authFailed = false.obs;

  // Master Key related state
  final Rx<bool> _isLoading = false.obs;
  final Rx<bool> _isNewUser = false.obs;
  final Rx<bool> _obscureMasterKey = true.obs;
  final Rx<bool> _obscureConfirm = true.obs;
  final Rx<String?> _errorMessage = Rx<String?>(null);

  bool get isAuthenticating => _isAuthenticating.value;
  bool get authFailed => _authFailed.value;

  bool get isLoading => _isLoading.value;
  bool get isNewUser => _isNewUser.value;
  bool get obscureMasterKey => _obscureMasterKey.value;
  bool get obscureConfirm => _obscureConfirm.value;
  String? get errorMessage => _errorMessage.value;

  @override
  void onClose() {
    _isAuthenticating.close();
    _authFailed.close();

    _isLoading.close();
    _isNewUser.close();
    _obscureMasterKey.close();
    _obscureConfirm.close();
    _errorMessage.close();
  }
}
