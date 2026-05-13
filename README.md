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
├── screens/      # UI Screens and Feature implementation
│   ├── auth/     # Authentication forms and logic
│   ├── app/      # Core user features (Dashboard, Wallet, Rewards)
│   ├── admin/    # Admin panel for user management
│   └── shared/   # Common screens like Loading or Error
├── services/     # API repositories and Firebase services
├── themes/       # Dark/Light theme definitions
└── widgets/      # Reusable UI components

---

## 📱 Feature & UI Map

Here is a breakdown of the key UI files and the features they handle:

### 🔐 Authentication & Onboarding
- **`landing_screen.dart`**: The entry point of the app with options for Social login (Google/Apple) and Email.
- **`auth_form.dart`**: Dynamic form handling both Login and Registration with real-time validation.
- **`auth_gate.dart`**: A smart wrapper that listens to auth state changes and routes users to either the Landing or Home screen.

### 👤 Member Features (User Side)
- **`user_dashboard_screen.dart`**: Personalized home screen showing point balance, tier status, and quick action buttons.
- **`wallet_screen.dart`**: Detailed view of transaction history, loyalty points, and digital membership card.
- **`rewards_screen.dart`**: Marketplace for browsing and redeeming exclusive vouchers and perks.
- **`profile_screen.dart` & `edit_profile_screen.dart`**: Personal info management and app settings.
- **`member_layout.dart`**: Provides the persistent bottom navigation and consistent layout across user screens.

### 🛡️ Admin Panel
- **`admin_dashboard_screen.dart`**: High-level overview and navigation for administrative tasks.
- **`manage_users_screen.dart`**: List of all registered members with search and filtering capabilities.
- **`admin_edit_user_screen.dart`**: Interface to manually adjust user points, change roles (Admin/User), and update member info.

### 🛠️ Core Components
- **`dashboard_screen.dart`**: Multi-functional dashboard containing the QR Scanner and real-time updates.
- **`loading_screen.dart`**: A premium, custom-animated loading experience used during data fetching.

---

## 🔧 Useful Commands

| Command | Purpose |
| :--- | :--- |
| `flutter analyze` | Check for code errors and warnings |
| `dart format .` | Format all files according to Dart guidelines |
| `flutter clean` | Clear build cache (useful for fixing build errors) |
| `flutter doctor` | Check your Flutter environment status |

---

## 👨‍💻 Project Lead Developer

**Rumel Ahmed**
*Project Lead Developer at Global Talent Hire Company*

Feel free to connect or reach out for inquiries:

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mrrajrumel)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mrrajrumel/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/mrrajrumel/)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/mrrajrumel/)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:rajrum3l@gmail.com)

---

## 📜 License

This project is proprietary and confidential. Unauthorized copying of this file, via any medium, is strictly prohibited.
Designed and Developed for **Suit Pro London**.
