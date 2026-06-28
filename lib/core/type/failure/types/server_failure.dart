import '../app_error_messages.dart';
import '../failure.dart';

class ServerFailure extends Failure {
  ServerFailure(this.code) : super(msg: AppErrorMessages.unexpectedServerError);

  final String code;
}
