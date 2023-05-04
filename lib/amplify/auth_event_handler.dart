import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class AuthEventHandler {
  VoidCallback? signedInCallback;
  VoidCallback? signedOutCallback;
  VoidCallback? sessionExpiredCallback;
  VoidCallback? userDeletedCallback;

  AuthEventHandler({
    this.signedInCallback,
    this.signedOutCallback,
    this.sessionExpiredCallback,
    this.userDeletedCallback,
  });

  handleAuthEvents() {
    Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) {
      switch (event.type) {
        case AuthHubEventType.signedIn:
          safePrint('User is signed in.');
          // signedInCallback!();
          break;
        case AuthHubEventType.signedOut:
          safePrint('User is signed out.');
          // signedOutCallback!();
          break;
        case AuthHubEventType.sessionExpired:
          safePrint('The session has expired.');
          // sessionExpiredCallback!();
          break;
        case AuthHubEventType.userDeleted:
          safePrint('The user has been deleted.');
          // userDeletedCallback!();
          break;
      }
    });
  }
}
