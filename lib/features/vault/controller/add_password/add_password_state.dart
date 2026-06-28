part of 'add_password_controller.dart';

@getxState
class AddPasswordState {
  AddPasswordState({required this.selectedCategory, this.enableBtn = false});

  final VaultCategory selectedCategory;
  final bool enableBtn;
}
