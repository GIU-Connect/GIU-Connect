import 'package:logger/logger.dart';

class AuthExceptionHandler {
  static AuthResultStatus handleException(e) {
    AuthResultStatus status;
    switch (e.code) {
      case 'invalid-email':
        status = AuthResultStatus.invalidEmail;
        break;
      case 'wrong-password':
        status = AuthResultStatus.wrongPassword;
        break;
      case 'user-not-found':
        status = AuthResultStatus.userNotFound;
        break;
      case 'user-disabled':
        status = AuthResultStatus.userDisabled;
        break;
      case 'too-many-requests':
        status = AuthResultStatus.tooManyRequests;
        break;
      case 'operation-not-allowed':
        status = AuthResultStatus.operationNotAllowed;
        break;
      case 'email-already-in-use':
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case 'weak-password':
        status = AuthResultStatus.weakPassword;
        break;
      case 'invalid-verification-code':
        status = AuthResultStatus.invalidVerificationCode;
        break;
      case 'invalid-verification-id':
        status = AuthResultStatus.invalidVerificationId;
        break;
      case 'credential-already-in-use':
        status = AuthResultStatus.credentialAlreadyInUse;
        break;
      case 'invalid-credential':
        status = AuthResultStatus.invalidCredential;
        break;
      case 'account-exists-with-different-credential':
        status = AuthResultStatus.accountExistsWithDifferentCredential;
        break;
      case 'invalid-password':
        status = AuthResultStatus.invalidPassword;
        break;
      case 'requires-recent-login':
        status = AuthResultStatus.requiresRecentLogin;
        break;
      case 'provider-already-linked':
        status = AuthResultStatus.providerAlreadyLinked;
        break;
      case 'no-such-provider':
        status = AuthResultStatus.noSuchProvider;
        break;
      case 'network-request-failed':
        status = AuthResultStatus.networkRequestFailed;
        break;
      case 'expired-action-code':
        status = AuthResultStatus.expiredActionCode;
        break;
      case 'invalid-action-code':
        status = AuthResultStatus.invalidActionCode;
        break;
      case 'internal-error':
        status = AuthResultStatus.internalError;
        break;
      case 'invalid-api-key':
        status = AuthResultStatus.invalidApiKey;
        break;
      case 'app-not-authorized':
        status = AuthResultStatus.appNotAuthorized;
        break;
      case 'keychain-error':
        status = AuthResultStatus.keychainError;
        break;
      case 'user-token-expired':
        status = AuthResultStatus.userTokenExpired;
        break;
      case 'api-key-not-valid.-please-pass-a-valid-api-key.':
        status = AuthResultStatus.invalidApiKey;
        Logger().e('API key is not valid');
        break;
      default:
        Logger().e('Case ${e.code} is not yet implemented');
        status = AuthResultStatus.undefined;
    }

    return status;
  }

  static String generateErrorMessage(AuthResultStatus status) {
    switch (status) {
      case AuthResultStatus.invalidEmail:
        return 'The email address is badly formatted.';
      case AuthResultStatus.wrongPassword:
        return 'Your password is incorrect.';
      case AuthResultStatus.userNotFound:
        return 'No user corresponding to the email address.';
      case AuthResultStatus.userDisabled:
        return 'The user account has been disabled by an administrator.';
      case AuthResultStatus.tooManyRequests:
        return 'Too many requests. Try again later.';
      case AuthResultStatus.operationNotAllowed:
        return 'Email/password accounts are not enabled.';
      case AuthResultStatus.emailAlreadyExists:
        return 'An account already exists with that email address.';
      case AuthResultStatus.weakPassword:
        return 'The password must be 6 characters long or more.';
      case AuthResultStatus.invalidVerificationCode:
        return 'The verification code entered is invalid.';
      case AuthResultStatus.invalidVerificationId:
        return 'The verification ID entered is invalid.';
      case AuthResultStatus.credentialAlreadyInUse:
        return 'This credential is already associated with a different user account.';
      case AuthResultStatus.invalidCredential:
        return 'Invalid Email/Password.';
      case AuthResultStatus.accountExistsWithDifferentCredential:
        return 'An account already exists with the same email address but different sign-in credentials.';
      case AuthResultStatus.invalidPassword:
        return 'The password is invalid or the user does not have a password.';
      case AuthResultStatus.requiresRecentLogin:
        return 'This operation is sensitive and requires recent authentication. Log in again before retrying.';
      case AuthResultStatus.providerAlreadyLinked:
        return 'The provider has already been linked to the user.';
      case AuthResultStatus.noSuchProvider:
        return 'This user does not have the provider enabled.';
      case AuthResultStatus.networkRequestFailed:
        return 'A network error occurred. Please try again.';
      case AuthResultStatus.expiredActionCode:
        return 'The action code has expired.';
      case AuthResultStatus.invalidActionCode:
        return 'The action code is invalid. This can happen if the code is malformed or has already been used.';
      case AuthResultStatus.internalError:
        return 'An internal error occurred. Please try again later.';
      case AuthResultStatus.invalidApiKey:
        return 'Your API key is invalid. Please check your Firebase configuration.';
      case AuthResultStatus.appNotAuthorized:
        return 'This app is not authorized to use Firebase Authentication.';
      case AuthResultStatus.keychainError:
        return 'An error occurred while accessing the keychain. Please try again.';
      case AuthResultStatus.userTokenExpired:
        return 'The user’s credential has expired. Please sign in again.';

      default:
        return 'An undefined error occurred.';
    }
  }
}

enum AuthResultStatus {
  invalidEmail,
  wrongPassword,
  userNotFound,
  userDisabled,
  tooManyRequests,
  operationNotAllowed,
  emailAlreadyExists,
  weakPassword,
  invalidVerificationCode,
  invalidVerificationId,
  credentialAlreadyInUse,
  invalidCredential,
  accountExistsWithDifferentCredential,
  invalidPassword,
  requiresRecentLogin,
  providerAlreadyLinked,
  noSuchProvider,
  networkRequestFailed,
  expiredActionCode,
  invalidActionCode,
  internalError,
  invalidApiKey,
  appNotAuthorized,
  keychainError,
  userTokenExpired,
  undefined,
}
