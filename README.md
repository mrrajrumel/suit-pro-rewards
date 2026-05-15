# Suit Pro Rewards - Flutter

![Suit Pro Rewards](Suit-Pro.png)

Suit Pro Rewards is a premium loyalty and rewards application for **Suit Pro London**. Migrated from React Native to Flutter, this version offers superior performance, smooth animations, and a robust codebase optimized for both Android and iOS.

---

## 🚀 Key Features

- **Exclusive Rewards**: Access and redeem loyalty points and vouchers.
- **Real-time Sync**: Seamless integration with the Suit Pro London website and Firebase.
- **Smart Wallet**: Track points, tier status (Silver, Gold, Platinum), and history.
- **Sartorial AI**: Instant expert advice on bespoke style & garment care.
- **QR Scanner**: Built-in mobile scanner for seamless in-store transactions.
- **Premium UI**: Dark-themed, high-end design with smooth frosted-glass effects.

---

## 🛠️ Tech Stack

- **State Management**: [Riverpod](https://riverpod.dev/)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Messaging, Storage)
- **Networking**: [Dio](https://pub.dev/packages/dio) for REST API integration.
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) for deep-linking and declarative navigation.
- **Animations**: [Flutter Animate](https://pub.dev/packages/flutter_animate)
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
flutter build apk --release --split-per-abi
```
*Output: `build/app/outputs/flutter-apk/app-release.apk`*

**Generate App Bundle (For Play Store)**
```bash
flutter build appbundle --release
```
*Output: `build/app/outputs/bundle/release/app-release.aab`*

### iOS
**Generate IPA (For App Store/TestFlight)**
```bash
flutter build ios --release --no-codesign
```
*Note: You must have an active Apple Developer account and configure signing in Xcode for production builds.*

---

## 📂 Project Structure

```text
lib/
├── core/             # App-wide constants and Firebase configuration
├── models/           # Data models (User, Activity, Order, Voucher, etc.)
├── providers/        # Riverpod state management (ViewModels & Providers)
│   └── admin/        # Administrative state logic
├── routes/           # GoRouter navigation configuration
├── screens/          # UI Screen implementations
│   ├── admin/        # Administrative dashboard and user management
│   ├── app/          # Core user features (Dashboard, Wallet, Rewards)
│   │   └── components/ # Feature-specific UI components
│   └── auth/         # Authentication forms
├── services/         # API repositories and business logic services
├── themes/           # App-wide styling and themes
├── utils/            # Utility classes and helpers
└── widgets/          # Reusable global UI components (Logo, Button, etc.)
```

---

## 📱 Feature & UI Map

Here is a breakdown of the key UI files and the features they handle:

### 🔐 Authentication & Onboarding
- **`landing_screen.dart`**: The entry point with Social login (Google), Phone, and Email options.
- **`onboarding_screen.dart`**: Multi-step setup for name, contact, and garment sizes.
- **`auth_gate.dart`**: Listens to auth state changes to route users appropriately.

### 👤 Member Features (User Side)
- **`dashboard_screen.dart`**: Main home screen with points balance, product picks, and quick actions.
- **`wallet_screen.dart`**: Detailed transaction history and digital membership card.
- **`rewards_screen.dart`**: Market for browsing and redeeming exclusive perks.
- **`profile_screen.dart`**: Personal info, measurements, and app settings.
- **`member_layout.dart`**: Persistent bottom navigation and unified app layout.
- **`referral_screen.dart`**: Program for sharing invite codes and earning bonuses.

### 🛡️ Admin Panel
- **`admin_dashboard_screen.dart`**: Management overview for staff.
- **`manage_users_screen.dart`**: Member directory with search and filtering.
- **`admin_edit_user_screen.dart`**: Direct adjustment of user points and roles.

### 🛠️ Core UI Components
- **`ai_style_guide.dart`**: AI-powered concierge for garment care advice.
- **`lifestyle_concierge.dart`**: Tier-based product recommendations.
- **`glass_container.dart`**: Premium frosted-glass effect used across the app.

---

## 🔧 Useful Commands

| Command | Purpose |
| :--- | :--- |
| `flutter pub get` | Install project dependencies |
| `flutter analyze` | Check for code errors and warnings |
| `dart format .` | Format all files according to Dart guidelines |
| `flutter clean` | Clear build cache |
| `flutter doctor` | Check Flutter environment status |

---

## 👨‍💻 Project Lead Developer

**Rumel Ahmed**  
*Project Lead Developer at Global Talent Hire Company*

Feel free to connect or reach out for inquiries:

<div align="left">

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mrrajrumel)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mrrajrumel/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/mrrajrumel/)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/mrrajrumel/)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:rajrum3l@gmail.com)

</div>

---

## 📜 License

This project is proprietary and confidential. Unauthorized copying of this file, via any medium, is strictly prohibited.
Designed and Developed for **Suit Pro London**.
