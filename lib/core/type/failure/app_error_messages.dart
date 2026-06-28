import '../error_message_type.dart';

abstract final class AppErrorMessages {
  static const ErrorMessage userNotAuthenticated = 'User not authenticated';
  static const ErrorMessage somethingWentWrong = 'Something went wrong';
  static const ErrorMessage noDataFound = 'No data found';
  static const ErrorMessage noInternetConnection = 'No internet connection';
  static const ErrorMessage imageUploadFailed = 'Image upload failed';
  static const ErrorMessage userNotFound = 'User not found';
  static const ErrorMessage syncCancelled = 'Sync cancelled';
  static const ErrorMessage unexpectedServerError = 'Unexpected server error';
  static const ErrorMessage aiAnalysisFailed =
      'AI analysis failed. Please try again.';
  static const ErrorMessage quotaExceeded =
      'AI limit reached. Please try again later.';
  static const ErrorMessage unsupportedImage =
      'The provided image format is not supported.';
}
