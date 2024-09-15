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
      default:
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
  undefined,
}
