part of 'gateway_controller.dart';

class _GatewayState extends GetxState {
  final _status = StatusEnum.base.obs;
  final RxBool _authFailed = false.obs;

  // Master Key related state
  final Rx<bool> _isNewUser = false.obs;
  final Rx<bool> _obscureMasterKey = true.obs;
  final Rx<bool> _obscureConfirm = true.obs;
  final Rx<String?> _errorMessage = Rx<String?>(null);

  StatusEnum get status => _status.value;
  bool get isLoading => _status.value == StatusEnum.loading;
  bool get isAuthenticating => _status.value == StatusEnum.loading;
  bool get authFailed => _authFailed.value;
  bool get isNewUser => _isNewUser.value;
  bool get obscureMasterKey => _obscureMasterKey.value;
  bool get obscureConfirm => _obscureConfirm.value;
  String? get errorMessage => _errorMessage.value;

  @override
  void onClose() {
    _status.close();
    _authFailed.close();

    _isNewUser.close();
    _obscureMasterKey.close();
    _obscureConfirm.close();
    _errorMessage.close();
  }
}
