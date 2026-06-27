import 'package:rxget/rxget.dart';
import 'package:rxget_annotation/rxget_annotation.dart';

import '../../../../service/password_manager/domain/entities/vault_entry.dart';

part 'add_password_state.dart';
part 'add_password_controller.g.dart';

class AddPasswordController extends GetxController<_AddPasswordState> {
  AddPasswordController({required VaultCategory selectedCategory})
    : state = _AddPasswordState(selectedCategory: selectedCategory);

  @override
  _AddPasswordState state;

  void changeCategory(VaultCategory category) => _changeCategory(category);

  void _changeCategory(VaultCategory category) {
    state._selectedCategory.value = category;
  }
}
