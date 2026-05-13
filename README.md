# Suit Pro Rewards - Flutter

This is the Flutter version of the Suit Pro Rewards app, migrated from React Native.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [VS Code](https://code.visualstudio.com/)
- [Flutter extension for VS Code](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

### Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

### Useful Commands

- **Analyze Code**: `flutter analyze`
- **Clean Project**: `flutter clean`
- **Format Code**: `dart format .`
- **Upgrade Flutter**: `flutter upgrade`

### Build

**Android**

```bash
flutter build apk
flutter build appbundle
```

**iOS**

```bash
flutter build ios
```

## Migration Notes

### What was converted

- The entire app was converted from React Native to Flutter.
- All screens, UI design, spacing, fonts, colors, icons, animations, transitions, and responsiveness were preserved.
- All current app features and business logic were maintained.
- The performance and code structure were optimized for production.

### What was removed

- Unused packages, dead code, deprecated libraries, and duplicate assets were removed.
- Unused screens/components and unused node modules references were removed.
- React-only configurations not needed anymore were removed.

### What was optimized

- The rendering was optimized.
- Unnecessary rebuilds were reduced.
- `const` widgets were used properly.
- The image loading was optimized.
- The startup speed was improved.

## Dependency Documentation

| React Native | Flutter |
| --- | --- |
| `@capacitor/push-notifications` | `firebase_messaging` |
| `@capacitor-firebase/authentication` | `firebase_auth` |
| `react-router-dom` | `go_router` |
| `@tanstack/react-query` | `flutter_riverpod` |
| `axios` | `dio` |
| `lucide-react` | `lucide_flutter` |
| `qrcode.react` | `qr_flutter` |
| `html5-qrcode` | `mobile_scanner` |
| `react-hot-toast` | `fluttertoast` |
| `framer-motion` | Flutter's animation framework |
| `tailwindcss` | Flutter's widget-based styling |

## Environment Setup Guide

### Flutter SDK

Follow the instructions on the [Flutter website](https://flutter.dev/docs/get-started/install) to install the Flutter SDK.

### VS Code

1. Install [VS Code](https://code.visualstudio.com/).
2. Install the [Flutter extension for VS Code](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter).

### Emulator/Device Setup

Follow the instructions on the [Flutter website](https://flutter.dev/docs/get-started/ws-test-drive?tab=android) to set up an emulator or a physical device.

## Firebase Setup Guide

1. Go to the [Firebase console](https://console.firebase.google.com/).
2. Create a new Firebase project, or use your existing `suitprolondonrewords` project.
3. Register your Flutter app with your Firebase project.
4. Download the `google-services.json` file for your Android app and place it in the `android/app` directory of your Flutter project.
5. Download the `GoogleService-Info.plist` file for your iOS app and place it in the `ios/Runner` directory of your Flutter project.
6. Add your Firebase project credentials to the `lib/core/firebase_options.dart` file.
