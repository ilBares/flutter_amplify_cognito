# amplify_cognito_mokup

A new Flutter project.

## Getting Started

## Prerequisites
1. TODO: AWS --> Amazon SNS --> Text Messagin (SMS) --> Account Information --> Exit SMS Sandbox
[https://docs.aws.amazon.com/sns/latest/dg/sns-sms-sandbox-moving-to-production.html]

2. For testing purpose --> Add phone number

Setup
1. __amplify configure__
  - user name: _amplify-cognito-user_
  - AWS --> IAM --> Users --> Add Users --> Attach ... --> AdministratorAccess-Amplify
  - select created user --> Security Credentials --> Create Access Key
  - access key: _AKIA3YCDKASTHMQTHYUR_
  - secret access key: _p93+9D2sTpOn1tr6vL6ID0UZNIMBfhEjiOC/51Fm_
  - Profile Name: _amplify-cognito-user_

2. __amplify init__
  - Choose [AWS profile] --> _amplify-cognito-user_

3. __amplify add auth__
  - Choose [Manual configuration] --> [User Sign-Up & Sign-In only]
  - friendly name: _phoneauthmokup_
  - user pool: _phoneuserpool_
  - Choose [Phone Number]
  - Choose [No]   https://docs.amplify.aws/cli/auth/groups/
  - Choose [No]   https://docs.amplify.aws/cli/auth/admin/

  - Choose [OFF]
  - Choose [Disabled (Uses SMS/TOTP as an alternative)]
  - Digit "Il tuo codice di verifica per amplify_cognito_mokup è {####}"
  - Digit "N"
  - Choose [Nickname] and [Phone Number]
  - Digit "30" (or more)
  - Digit "N"
  - Enter
  - Choose [No]
  - Digit "N" (but Lambda Triggers are intresting)

4. __amplify push__

5. __amplify status__ (Optional)


## Flutter
1. Run __flutter create amplify_cognito_mokup__ in the terminal

2. Add the following dependencies:
*  [pubspec] amplify_auth_cognito: ^1.0.0
*  [pubspec] amplify_authenticator: ^1.0.0
*  [pubspec] amplify_flutter: ^1.0.0

4. Add _platform :ios, '13.0'_ in ios/Podfile (second line)

5. Substitute _minSdkVersion flutter.minSdkVersion_ with _minSdkVersion 24_

6. Write code to initialize Amplify in the application