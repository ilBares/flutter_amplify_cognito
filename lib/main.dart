import 'package:flutter/material.dart';

// REQUIRED
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_cognito_mokup/amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

void main() => runApp(MyWidget());

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _result = "No result";

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    // Add any Amplify plugins you want to use
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    // You can use addPlugins if you are going to be adding multiple plugins
    // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint("Tried to reconfigure Amplify.");
    }
  }

  // USED TO SIGN UP THE USER
  Future<void> signUpWithPhoneVerification(
    String username,
    String password,
    String phoneNumber,
  ) async {
    final userAttributes = <AuthUserAttributeKey, String>{
      AuthUserAttributeKey.phoneNumber: phoneNumber,
      // AuthUserAttributeKey.nickname: nickname,
    };

    final result = await Amplify.Auth.signUp(
      username: username,
      password: password,
      options: SignUpOptions(
        userAttributes: userAttributes,
      ),
    );

    print(result);
    setState(() {
      _result =
          'isSignUpComplete: ${result.isSignUpComplete} \nnextStep: ${result.nextStep}';
      ;
    });
  }

  // USED TO CONFIRM SIGN UP
  Future<void> confirmSignUpPhoneVerification(
    String username,
    String otpCode,
  ) async {
    final result = Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: otpCode,
    );

    print(result);
    setState(() {
      result.asStream().forEach((element) {
        _result +=
            'isSignUpComplete: ${element.isSignUpComplete} \nnextStep: ${element.nextStep} \nuserId: ${element.userId}';
      });
    });
  }

  // USED TO SIGN IN
  Future<void> signInWithPhoneVerification(
    String username,
    String password,
  ) async {
    final result = await Amplify.Auth.signIn(
      username: username,
      password: password,
    );

    print(result);
    setState(() {
      _result =
          'isSignedIn: ${result.isSignedIn} \nnextStep: ${result.nextStep}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              children: [
                ///
                /// LOGIN
                ///
                ElevatedButton(
                  child: const Text('LOGIN'),
                  onPressed: () {
                    signUpWithPhoneVerification(
                      '+393667097756',
                      'TestPassword01.',
                      '+393667097756',
                    );
                  },
                ),

                ///
                /// CONFIRM SIGN IN
                ///
                ElevatedButton(
                  child: const Text('CONFIRM'),
                  onPressed: () {
                    confirmSignUpPhoneVerification(
                      '+393667097756',
                      '157311',
                    );
                  },
                ),

                ///
                /// SIGN IN
                ///
                ElevatedButton(
                  child: const Text('SIGN IN'),
                  onPressed: () {
                    signInWithPhoneVerification(
                      '+393667097756',
                      'TestPassword01.',
                    );
                  },
                ),

                Text(_result),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
