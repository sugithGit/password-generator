import '../app_error_messages.dart';
import '../failure.dart';

class NoInternetConnectionFailure extends Failure {
  NoInternetConnectionFailure()
    : super(msg: AppErrorMessages.noInternetConnection);
}
