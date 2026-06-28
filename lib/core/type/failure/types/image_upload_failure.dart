import '../app_error_messages.dart';
import '../failure.dart';

class ImageUploadFailure extends Failure {
  ImageUploadFailure() : super(msg: AppErrorMessages.imageUploadFailed);
}
