import '../app_error_messages.dart';
import '../failure.dart';

class CommonFailure extends Failure {
  CommonFailure() : super(msg: AppErrorMessages.somethingWentWrong);
}
