part of 'auth_controller.dart';

class _AuthState extends GetxState {
  final _status = StatusEnum.base.obs;
  StatusEnum get status => _status.value;

  final Rxn<AuthUser> _user = Rxn<AuthUser>();
  final RxnString _error = RxnString();
  final RxBool _isSignUp = false.obs;

  final Rxn<AuthType> _authType = Rxn<AuthType>();
  AuthType? get authType => _authType.value;

  bool get isGoogleLoading => isLoading && authType == AuthType.google;
  bool get isEmailLoading => isLoading && authType == AuthType.email;

  bool get isLoading => _status.value == .loading;
  AuthUser? get user => _user.value;
  String? get error => _error.value;
  bool get isSignUp => _isSignUp.value;

  @override
  void onClose() {
    _status.close();
    _user.close();
    _error.close();
    _isSignUp.close();
    _authType.close();
  }
}
