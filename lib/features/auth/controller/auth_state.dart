part of 'auth_controller.dart';

class _AuthState extends GetxState {
  final _status = StatusEnum.base.obs;
  StatusEnum get status => _status.value;

  final Rxn<AuthUser> _user = Rxn<AuthUser>();
  final RxnString _error = RxnString();
  final RxBool _isSignUp = false.obs;

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
  }
}
