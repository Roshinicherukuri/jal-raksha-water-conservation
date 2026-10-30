# Jal Raksha — Water Conservation App

Jal Raksha is a Flutter application that encourages responsible water use through daily consumption logging and rainwater-harvesting awareness. Firebase Authentication handles user sign-in, while Cloud Firestore stores each user's usage records in the cloud.

## Features

- Email/password registration and sign-in with Firebase Authentication
- Log water usage by activity and litres
- Live total of today's recorded consumption
- Recent usage history
- Rainwater-harvesting awareness tips
- User-scoped Firestore data access
- Material 3 interface with simple navigation

## Tech stack

Flutter · Dart · Firebase Authentication · Cloud Firestore · Git · GitHub

## Project structure

```text
jal-raksha-water-conservation/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── auth_gate.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   └── rainwater_screen.dart
│   └── services/
│       └── water_service.dart
├── firestore.rules
├── pubspec.yaml
└── README.md
```

## Setup

### 1. Install prerequisites

Install Flutter SDK and Android Studio (or Xcode for iOS). Verify your setup:

```bash
flutter doctor
```

### 2. Create a Firebase project

1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Create a project named `jal-raksha` (or choose another name).
3. Add your Android and/or iOS app using the application ID you configure.
4. Enable **Authentication → Sign-in method → Email/Password**.
5. Create a **Cloud Firestore** database.
6. Install the FlutterFire CLI and configure the project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

The generated `firebase_options.dart` can be used with the default Firebase initialization. To use it, update `lib/main.dart`:

```dart
import 'firebase_options.dart';

// Replace Firebase.initializeApp() with:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Without this generated configuration, the default initialization requires the native Firebase configuration files to be installed for each target platform.

### 3. Install dependencies and run

```bash
flutter pub get
flutter run
```

### 4. Apply Firestore rules

Copy the contents of `firestore.rules` into the Firebase Console's Firestore Rules editor and publish. These rules restrict each signed-in user to their own usage records.

## Firestore data model

```text
users/{userId}/water_usage/{entryId}
    litres: number
    activity: string
    createdAt: timestamp
```

Each account stores its own entries beneath its Firebase Authentication UID.

## Notes and limitations

- This is a starter/portfolio implementation. Configure Firebase for your own project before running it.
- The daily total is calculated from records whose server timestamp falls within the current local day.
- Firestore may request a composite index for combined range filters; follow the index-creation link in the Firebase error if one is requested.
- Water-use figures are user-entered estimates, not measurements from smart meters.
- Rainwater harvesting guidance is educational. Drinking water needs suitable treatment and quality testing; groundwater recharge structures must follow local regulations and professional guidance.

## Future enhancements

- Weekly and monthly usage charts
- Daily conservation goals and reminders
- Household profiles and shared usage
- Rainfall data and rainwater collection estimator
- Local-language content and accessibility improvements
- Unit tests and Firebase Emulator Suite tests
