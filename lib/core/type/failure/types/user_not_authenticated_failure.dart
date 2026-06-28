import '../app_error_messages.dart';
import '../failure.dart';

/// Represents a failure when there is no active authenticated session.
///
/// **Authentication vs Identity/Database Existence:**
/// * [UserNotAuthenticatedFailure] occurs when the user is completely logged out,
///   meaning their authentication credentials or token session does not exist (e.g., `auth.currentUser == null`).
/// * [UserNotFoundFailure] occurs when the session is active/authenticated, but the user's
///   underlying database record/profile (e.g., in a Supabase table) does not exist or
///   could not be retrieved.
class UserNotAuthenticatedFailure extends Failure {
  UserNotAuthenticatedFailure()
    : super(msg: AppErrorMessages.userNotAuthenticated);
}
