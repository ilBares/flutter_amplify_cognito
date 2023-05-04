import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';

/// A utility class that provides methods for configuring and using Amazon
/// Cognito authentication using Amplify in a Flutter application.
class CognitoUtils {
  /// Configures Amplify with the AmplifyAuthCognito plugin using the provided
  /// `amplifyconfig` JSON string.
  /// This method must be called before any other Amplify methods can be used.
  ///
  /// Throws an AmplifyAlreadyConfiguredException if Amplify has already been
  /// configured.
  ///
  /// Example usage:
  ///
  /// ```
  /// await CognitoUtils.configureAmplify("""
  /// {
  ///   "auth": {
  ///     "plugins": {
  ///       "awsCognitoAuthPlugin": {
  ///         "region": "us-east-1",
  ///         "userPoolId": "YOUR_USER_POOL_ID",
  ///         "userPoolWebClientId": "YOUR_USER_POOL_APP_CLIENT_ID"
  ///       }
  ///     }
  ///   }
  /// }
  /// """);
  /// ```
  static Future<void> configureAmplify(String amplifyconfig) async {
    // Add any Amplify plugins you want to use
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    // You can use addPlugins if you are going to be adding multiple plugins
    // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.

    // Once Plugins are added, configure Amplify
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint("Tried to reconfigure Amplify.");
      rethrow;
    }
  }

  /// Signs up a new user with the provided `username`, `password`, and `phoneNumber`.
  ///
  /// The `userAttributes` parameter can be used to provide additional user attributes, such as a nickname,
  /// using the `AuthUserAttributeKey` enum.
  ///
  /// Throws an AuthException if the sign up operation fails.
  ///
  /// Example usage:
  ///
  /// ```
  /// final result = await CognitoUtils.signUpWithPhoneVerification(
  ///   "john_doe",
  ///   "password123",
  ///   "+1234567890",
  ///   userAttributes: {
  ///     AuthUserAttributeKey.nickname: "John Doe",
  ///   },
  /// );
  /// ```
  static Future<SignUpResult> signUpWithPhoneVerification(
    String username,
    String password,
    String phoneNumber,
    String nickname,
    String gender,
    DateTime birthDate,
  ) async {
    final userAttributes = <AuthUserAttributeKey, String>{
      AuthUserAttributeKey.phoneNumber: phoneNumber,
      AuthUserAttributeKey.nickname: nickname,
      AuthUserAttributeKey.gender: gender,

      // WARNING: [flutter pub add intl] required
      AuthUserAttributeKey.birthdate:
          DateFormat('yyyy-MM-dd').format(birthDate),
    };

    try {
      final result = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      return result;
    } on AuthException catch (e) {
      safePrint('Error signing up user: ${e.message}');
      rethrow;
    }
  }

  /// Confirms the sign-up of a user with a phone number using the provided OTP code.
  ///
  /// Returns a `SignUpResult` object representing the result of the confirmation operation,
  /// or throws an `AuthException` if an error occurs during the operation.
  ///
  /// The `username` parameter is the username of the user whose sign-up is being confirmed.
  ///
  /// The `otpCode` parameter is the OTP code sent to the user's phone number during the sign-up process.
  ///
  /// Example usage:
  /// ```
  /// final result = await CognitoUtils.confirmSignUpPhoneVerification('johndoe', '123456');
  /// if (result.isSignUpComplete) {
  ///   print('Sign-up confirmed for user ${result.nextStep.signInStep}.');
  /// } else {
  ///   print('User is not yet confirmed. Awaiting additional steps: ${result.nextStep.signInStep}.');
  /// }
  /// ```
  static Future<SignUpResult> confirmSignUpPhoneVerification(
    String username,
    String otpCode,
  ) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: otpCode,
      );
      return result;
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
      rethrow;
    }
  }

  /// Resends the confirmation code for a user's phone number verification.
  ///
  /// Returns a `ResendSignUpCodeResult` object representing the result of the resend operation,
  /// or throws an `AuthException` if an error occurs during the operation.
  ///
  /// The `username` parameter is the username of the user whose confirmation code should be resent.
  ///
  /// Example usage:
  /// ```
  /// final result = await CognitoUtils.reconfirmSignUpPhoneVerification('johndoe');
  /// print('Result: $result');
  /// ```
  static Future<ResendSignUpCodeResult> reconfirmSignUpPhoneVerification(
    username,
  ) async {
    try {
      final result = await Amplify.Auth.resendSignUpCode(username: username);
      return result;
    } on AuthException catch (e) {
      safePrint('Error resending code: ${e.message}');
      rethrow;
    }
  }

  /// Signs in a user with a phone number and password.
  ///
  /// Returns a `SignInResult` object representing the result of the sign-in operation,
  /// or throws an `AuthException` if an error occurs during the operation.
  ///
  /// The `username` parameter is the username of the user being signed in.
  ///
  /// The `password` parameter is the password of the user being signed in.
  ///
  /// Example usage:
  /// ```
  /// final result = await CognitoUtils.signInWithPhoneVerification('johndoe', 'password123');
  /// if (result.isSignedIn) {
  ///   print('User ${result.nextStep.signInStep} is signed in.');
  /// } else {
  ///   print('User is not yet signed in. Awaiting additional steps: ${result.nextStep.signInStep}.');
  /// }
  /// ```
  static Future<SignInResult> signInWithPhoneVerification(
    String username,
    String password,
  ) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      return result;
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      rethrow;
    }
  }

  static Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  static Future<SignOutResult> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();

    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }

    return result;
  }

  static Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  static Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (var element in result) {
        safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  // https://docs.amplify.aws/lib/auth/user-attributes/q/platform/flutter/#update-user-attribute
  static Future<void> updateUserNickname(String newNickname) async {
    try {
      final result = await Amplify.Auth.updateUserAttribute(
        userAttributeKey: AuthUserAttributeKey.nickname,
        value: newNickname,
      );
    } on AuthException catch (e) {
      safePrint('Error updating user attribute: ${e.message}');
    }
  }

  static Future<ResetPasswordResult> resetPassword(String username) async {
    try {
      final result = await Amplify.Auth.resetPassword(
        username: username,
      );
      return result;
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
      rethrow;
    }
  }

  static Future<UpdatePasswordResult> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final result = await Amplify.Auth.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return result;
    } on AuthException catch (e) {
      safePrint('Error updating password: ${e.message}');
      rethrow;
    }
  }

  static Future<ResetPasswordResult> confirmResetPassword({
    required String username,
    required String newPassword,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      return result;
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
      rethrow;
    }
  }

  static Future<void> deleteUser() async {
    try {
      await Amplify.Auth.deleteUser();
      safePrint('Delete user succeeded');
    } on AuthException catch (e) {
      safePrint('Delete user failed with error $e');
    }
  }
}
