import '../app_error_messages.dart';
import '../failure.dart';

class NoDataFoundFailure extends Failure {
  NoDataFoundFailure() : super(msg: AppErrorMessages.noDataFound);
}
