# Suit Pro Rewards - Flutter

![Suit Pro Rewards](Suit-Pro.png)

Suit Pro Rewards is a premium loyalty and rewards application for **Suit Pro London**. Migrated from React Native to Flutter, this version offers superior performance, smooth animations, and a robust codebase optimized for both Android and iOS.

---

## 🚀 Key Features

- **Exclusive Rewards**: Access and redeem loyalty points and vouchers.
- **Real-time Sync**: Seamless integration with the Suit Pro London website and Firebase.
- **Smart Wallet**: Track points, tier status (Silver, Gold, Platinum), and history.
- **Admin Panel**: Manage users, adjust points, and oversee rewards directly from the app.
- **QR Scanner**: Built-in mobile scanner for seamless transactions.
- **Responsive UI**: Optimized for all screen sizes with a premium dark theme.

---

## 🛠️ Tech Stack

- **State Management**: [Riverpod](https://riverpod.dev/)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Messaging, Storage)
- **Networking**: [Dio](https://pub.dev/packages/dio) for REST API integration.
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) for deep-linking and declarative navigation.
- **Icons**: [Lucide Flutter](https://pub.dev/packages/lucide_flutter)

---

## 📦 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/downloads/) (v17 recommended)
- **For iOS**: macOS with [Xcode](https://developer.apple.com/xcode/) and [CocoaPods](https://cocoapods.org/).

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/mrrajrumel/suit-pro-rewards.git
   cd suit-pro-rewards
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Place your `google-services.json` in `android/app/`.
   - Place your `GoogleService-Info.plist` in `ios/Runner/`.
   - Update `lib/core/firebase_options.dart` if you add new platforms.

---

## 🖥️ Running the App (Preview)

You can preview the app on different platforms using the commands below:

### 1. Web Preview (Chrome)
```bash
flutter run -d chrome
```

### 2. Android Preview (Emulator or Physical Device)
```bash
flutter run -d android
```

### 3. iOS Preview (Simulator or Physical Device)
```bash
flutter run -d ios
```

---

## 🏗️ Build Guide

### Android
**Generate APK (For testing/sharing)**
```bash
flutter build apk --release
```
*Output: `build/app/outputs/flutter-apk/app-release.apk`*

**Generate App Bundle (For Play Store)**
```bash
flutter build appbundle
```
*Output: `build/app/outputs/bundle/release/app-release.aab`*

### iOS
**Generate IPA (For App Store/TestFlight)**
```bash
flutter build ios --release
```
*Note: You must have an active Apple Developer account and configure signing in Xcode.*

---

## 📂 Project Structure

```text
lib/
├── core/         # Firebase configuration and app-wide constants
├── models/       # Data models (User, Activity, Reward, etc.)
├── providers/    # Riverpod state management logic
├── routes/       # GoRouter navigation configuration
├── screens/      # UI Screens (Auth, Home, Admin, Profile)
├── services/     # API repositories and Firebase services
├── themes/       # Dark/Light theme definitions
└── widgets/      # Reusable UI components
```

---

## 🔧 Useful Commands

| Command | Purpose |
| :--- | :--- |
| `flutter analyze` | Check for code errors and warnings |
| `dart format .` | Format all files according to Dart guidelines |
| `flutter clean` | Clear build cache (useful for fixing build errors) |
| `flutter doctor` | Check your Flutter environment status |

---

## 📜 License

This project is proprietary and confidential. Unauthorized copying of this file, via any medium, is strictly prohibited.
Designed and Developed for **Suit Pro London**.
