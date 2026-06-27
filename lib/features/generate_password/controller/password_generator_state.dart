part of 'password_generator_controller.dart';

class _PasswordGeneratorState extends GetxState {
  final RxInt _passwordLength = 10.obs;
  final RxInt _maxPasswordLength = 26.obs;
  final RxBool _isLowercase = true.obs;
  final RxBool _isUppercase = false.obs;
  final RxBool _isNumbers = false.obs;
  final RxBool _isSymbols = false.obs;
  final RxBool _isExcludeDuplicate = false.obs;
  final RxBool _isIncludeSpaces = false.obs;
  final RxList<Password> _passwordHistory = <Password>[].obs;
  final RxString _generatedPassword = ''.obs;
  final TextEditingController passwordController = TextEditingController(
    text: "",
  );

  int get passwordLength => _passwordLength.value;
  int get maxPasswordLength => _maxPasswordLength.value;
  bool get isLowercase => _isLowercase.value;
  bool get isUppercase => _isUppercase.value;
  bool get isNumbers => _isNumbers.value;
  bool get isSymbols => _isSymbols.value;
  bool get isExcludeDuplicate => _isExcludeDuplicate.value;
  bool get isIncludeSpaces => _isIncludeSpaces.value;
  List<Password> get passwordHistory => _passwordHistory;
  String get generatedPassword => _generatedPassword.value;

  @override
  void onClose() {
    _passwordLength.close();
    _maxPasswordLength.close();
    _isLowercase.close();
    _isUppercase.close();
    _isNumbers.close();
    _isSymbols.close();
    _isExcludeDuplicate.close();
    _isIncludeSpaces.close();
    _passwordHistory.close();
    _generatedPassword.close();
    passwordController.dispose();
  }
}
