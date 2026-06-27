part of 'auth_controller.dart';

class AuthState extends GetxState {
  final RxBool _isLoading = false.obs;
  final Rxn<AuthUser> _user = Rxn<AuthUser>();
  final RxnString _error = RxnString();

  bool get isLoading => _isLoading.value;
  AuthUser? get user => _user.value;
  String? get error => _error.value;

  @override
  void onClose() {
    _isLoading.close();
    _user.close();
    _error.close();
  }
}
