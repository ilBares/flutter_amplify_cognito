import 'package:amplify_cognito_mokup/amplify/auth_event_handler.dart';
import 'package:flutter/material.dart';

// REQUIRED
import 'package:amplify_cognito_mokup/amplify/cognito_utils.dart';
import 'package:amplify_cognito_mokup/amplifyconfiguration.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              const Size(300, 40),
            ),
          ),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('AWS COGNITO'),
          ),
          body: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  initState() {
    super.initState();
    _configureAmplify();
    AuthEventHandler authEventHandler = AuthEventHandler();
    authEventHandler.handleAuthEvents();
  }

  Future<void> _configureAmplify() async {
    await CognitoUtils.configureAmplify(amplifyconfig);
  }

  Future<void> _signUpWithPhoneVerification(
    String username,
    String password,
    String phoneNumber,
    String nickname,
    String gender,
    DateTime birthDate,
  ) async {
    final result = await CognitoUtils.signUpWithPhoneVerification(
      username,
      password,
      phoneNumber,
      nickname,
      gender,
      birthDate,
    );

    _showSnackbar(
      'isSignUpComplete: [${result.isSignUpComplete}] \nnextStep: [${result.nextStep}]',
    );
  }

  // USED TO CONFIRM SIGN UP
  Future<void> _confirmSignUpPhoneVerification(
    String username,
    String otpCode,
  ) async {
    final result = await CognitoUtils.confirmSignUpPhoneVerification(
      username,
      otpCode,
    );

    _showSnackbar(
      'isSignUpComplete: [${result.isSignUpComplete}] \nnextStep: [${result.nextStep}]',
    );
  }

  // USED TO RECONFIRM SIGN UP
  Future<void> _reconfirmSignUpPhoneVerification(String username) async {
    final result = await CognitoUtils.reconfirmSignUpPhoneVerification(
      username,
    );

    _showSnackbar(
      'isSigned: [${result.codeDeliveryDetails}]',
    );
  }

  // USED TO SIGN IN
  Future<void> _signIn(
    String username,
    String password,
  ) async {
    final result = await CognitoUtils.signInWithPhoneVerification(
      username,
      password,
    );

    _showSnackbar(
      'isSigned: [${result.isSignedIn}] \nnextStep: [${result.nextStep}]',
    );
  }

  Future<void> _isUserSignedIn() async {
    final result = await CognitoUtils.isUserSignedIn();

    _showSnackbar(
      'IsUserSignedIn: [$result]',
    );
  }

  Future<void> _signOut() async {
    final result = await CognitoUtils.signOutCurrentUser();

    _showSnackbar('${result.toJson()}');
  }

  Future<void> _getCurrentUser() async {
    final result = await CognitoUtils.getCurrentUser();

    _showSnackbar('Username: [${result.signInDetails.toJson()}]');
  }

  Future<void> _updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await CognitoUtils.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    _showSnackbar('Update password: [${result.toJson()}]');
  }

  Future<void> _resetPassword(String username) async {
    final result = await CognitoUtils.resetPassword(username);

    _showSnackbar(
      'Reset Password result: [${result.toJson()}]',
    );
  }

  Future<void> _confirmResetPassword(
    String username,
    String newPassword,
    String otpCode,
  ) async {
    final result = await CognitoUtils.confirmResetPassword(
      username: username,
      newPassword: newPassword,
      confirmationCode: otpCode,
    );

    _showSnackbar(
      'Confirm Reset Password result: [${result.toJson()}]',
    );
  }

  Future<void> _deleteUser() async {
    await CognitoUtils.deleteUser();
  }

  _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ///
          /// SIGN UP + OTP CODE
          ///
          ElevatedButton(
            onPressed: () {
              _signUpWithPhoneVerification(
                '+393667097756',
                'TestPassword01.',
                '+393667097756',
                '_marcobare',
                'MALE',
                DateTime(2001, 3, 10),
              );
            },
            child: const Text('SIGN UP'),
          ),

          ///
          /// RESEND OTP CODE
          ///
          ElevatedButton(
            onPressed: () {
              _reconfirmSignUpPhoneVerification(
                '+393667097756',
              );
            },
            child: const Text('RESEND OTP CODE'),
          ),

          ///
          /// CONFIRM SIGN UP
          ///
          ElevatedButton(
            onPressed: () {
              _confirmSignUpPhoneVerification(
                '+393667097756',
                '585575',
              );
            },
            child: const Text('CONFIRM'),
          ),

          ///
          /// SIGN IN
          ///
          ElevatedButton(
            onPressed: () {
              _signIn(
                '+393667097756',
                // 'TestPassword01.',
                'TestPassword01.',
              );
            },
            child: const Text('SIGN IN'),
          ),

          ///
          /// IS USER SIGNED IN
          ///
          ElevatedButton(
            onPressed: _isUserSignedIn,
            child: const Text('IS USER SIGNED IN'),
          ),

          ///
          /// SIGN OUT
          ///
          ElevatedButton(
            onPressed: _signOut,
            child: const Text('SIGN OUT'),
          ),

          ///
          /// GET CURRENT USER
          ///
          ElevatedButton(
            onPressed: _getCurrentUser,
            child: const Text('GET CURRENT USER'),
          ),

          ///
          /// UPDATE PASSWORD
          ///
          ElevatedButton(
            onPressed: () => _updatePassword(
              oldPassword: 'TestPassword01?',
              newPassword: 'TestPassword01.',
            ),
            child: const Text('UPDATE PASSWORD'),
          ),

          ///
          /// RESET PASSWORD
          ///
          ElevatedButton(
            onPressed: () => _resetPassword('+393667097756'),
            child: const Text('RESET PASSWORD'),
          ),

          ///
          /// CONFIRM RESET PASSWORD
          ///
          ElevatedButton(
            onPressed: () => _confirmResetPassword(
              '+393667097756',
              'TestPassword01?',
              '346886',
            ),
            child: const Text('CONFIRM RESET PASSWORD'),
          ),

          ///
          /// DELETE USER
          ///
          ElevatedButton(
            onPressed: _deleteUser,
            child: const Text('DELETE USER'),
          ),
        ],
      ),
    );
  }
}
