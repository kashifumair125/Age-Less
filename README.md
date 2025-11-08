# AgeLess - Biological Age Reversal

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.4.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success)
![License](https://img.shields.io/badge/License-Private-red)

**Track, analyze, and reverse your biological age with personalized health insights, comprehensive assessments, and evidence-based coaching.**

[Features](#-features) • [Screenshots](#-screenshots) • [Getting Started](#-getting-started) • [Tech Stack](#-technology-stack) • [Production](#-production-deployment)

</div>

---

## 🎯 Overview

AgeLess is a comprehensive mobile health application that helps you understand and improve your biological age through:

- 📊 **Real-time biological age calculation** using evidence-based algorithms
- 📈 **Daily health tracking** for nutrition, exercise, sleep, and stress
- 🎯 **Personalized coaching** based on your actual health data
- 🏆 **Gamified achievements** to keep you motivated
- 📱 **Wearable integration** with Google Fit and Apple Health
- 💾 **100% offline-first** - All data stored securely on your device
- 🌙 **Beautiful dark mode** with custom theming
- 💰 **Monetization ready** with AdMob integration

---

## ✨ Features

### Core Features

| Feature | Description | Status |
|---------|-------------|--------|
| **Dashboard** | Real-time biological age display with daily coaching tips | ✅ Working |
| **Health Assessment** | Comprehensive evaluation across 5 categories with scientific scoring | ✅ Working |
| **Daily Tracking** | Log nutrition, exercise, sleep, stress, and supplements | ✅ Working |
| **Progress Analytics** | Beautiful charts showing biological age trends and category scores | ✅ Working |
| **Rule-based Coaching** | Personalized daily messages based on your data and streaks | ✅ Working |
| **Achievements** | Unlock rewards for streaks and milestones | ✅ Working |
| **Profile Management** | Edit your personal information and health data | ✅ Working |
| **Data Export** | Export complete health data in JSON or CSV format | ✅ Working |
| **Wearable Sync** | Automatic sync with Google Fit (Android) and Apple Health (iOS) | ✅ Working |

### Advanced Features

- 📊 **Category Score Tracking** - Real scores for nutrition, exercise, sleep, stress, and social health
- 🔄 **Automatic Wearable Sync** - Import steps, calories, sleep, and workouts from your fitness tracker
- 💾 **Complete Data Export** - Export all your health data for backup or analysis
- ✏️ **Profile Editing** - Update height, weight, birth date, and other personal info
- 🎨 **Custom Dark Theme** - Professional dark mode that matches app branding
- 🔔 **Smart Notifications** - Daily reminders and achievement unlocks
- 🏅 **Streak System** - Track your consistency and build healthy habits
- 📉 **Trend Analysis** - See how your biological age changes over time

### Technical Features

- ✅ **100% Offline-First** - No internet required for core functionality
- ✅ **Privacy-Focused** - All data stored locally with Hive
- ✅ **No External APIs** - Works completely standalone
- ✅ **Cross-Platform** - Android, iOS, Web, Windows, macOS, Linux
- ✅ **Modern Architecture** - Clean architecture with domain-driven design
- ✅ **State Management** - Riverpod for reactive state
- ✅ **AdMob Integration** - Monetization-ready with banner ads
- ✅ **Production Ready** - Fully tested and deployment-ready

---

## 🖼️ Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/f069a929-b297-458f-bb61-8a00313cd6e0" width="30%" />
  <img src="https://github.com/user-attachments/assets/1c3c9880-a34e-4673-b008-f9443fb706a1" width="30%" />
  <img src="https://github.com/user-attachments/assets/26cd5189-61ad-419f-87b5-111323094596" width="30%" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/7cdaef56-3eef-4935-b676-285f307af88b" width="30%" />
</p>

---

## 🚀 Technology Stack

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.5.1 | State management and dependency injection |
| `go_router` | ^16.2.4 | Declarative routing and navigation |
| `hive` & `hive_flutter` | ^2.2.3 / ^1.1.0 | Local NoSQL database (offline-first) |
| `fl_chart` | ^1.1.1 | Beautiful charts and data visualization |
| `google_mobile_ads` | ^5.1.0 | AdMob integration for monetization |
| `health` | ^11.1.0 | Google Fit & Apple Health integration |
| `flutter_local_notifications` | ^19.4.2 | Push notifications and reminders |
| `google_fonts` | ^6.2.1 | Custom typography |
| `percent_indicator` | ^4.2.3 | Circular and linear progress indicators |
| `uuid` | ^4.5.1 | Unique ID generation |
| `permission_handler` | ^11.3.1 | Runtime permissions |
| `intl` | ^0.20.2 | Internationalization and date formatting |
| `timezone` | ^0.10.1 | Timezone support for notifications |

### Architecture

```
lib/
├── core/                    # Core utilities and configuration
│   ├── constants/           # App-wide constants
│   ├── router/              # Navigation (GoRouter)
│   ├── theme/               # Custom themes (light/dark)
│   └── utils/               # Helper utilities
├── data/                    # Data layer
│   ├── local/               # Hive configuration
│   ├── repositories/        # Data repositories
│   └── services/            # Platform services (AdMob, Notifications)
├── domain/                  # Business logic layer
│   ├── models/              # Domain models (Hive adapters)
│   └── services/            # Business services (calculators, coaching, export)
└── presentation/            # UI layer
    ├── providers/           # Riverpod state providers
    ├── screens/             # Feature screens
    └── widgets/             # Reusable widgets
```

**Clean Architecture Principles:**
- **Presentation Layer**: UI components, state management (Riverpod)
- **Domain Layer**: Business logic, use cases, entities
- **Data Layer**: Repositories, local storage (Hive), platform services

---

## 📦 Getting Started

### Prerequisites

- Flutter SDK 3.4.0 or higher
- Dart SDK 3.0+ (included with Flutter)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio with Flutter plugins

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/kashifumair125/Age-Less.git
cd Age-Less
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate Hive adapters:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app:**
```bash
flutter run
```

### Platform-Specific Setup

#### Android
- **Minimum SDK:** 21 (Android 5.0)
- **Target SDK:** Latest
- Supports Google Fit integration

#### iOS
- **Minimum iOS:** 12.0
- Requires Xcode for development
- Supports Apple Health integration

#### Web
```bash
flutter run -d chrome
```

#### Desktop
```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

---

## 🏗️ Development

### Running Tests
```bash
flutter test
```

### Code Generation
When you modify Hive models, regenerate adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build Commands

#### Development Build
```bash
flutter run --debug
```

#### Release Build (Android)
```bash
# APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### Release Build (iOS)
```bash
flutter build ios --release
```

#### Web Build
```bash
flutter build web --release
```

---

## 📱 Production Deployment

### 🎯 App is 100% Production Ready!

✅ **All features fully functional**
✅ **No external APIs required**
✅ **Offline-first architecture**
✅ **AdMob integration for monetization**
✅ **Comprehensive testing done**

### Pre-Publication Checklist

See **[PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)** for complete deployment guide including:

1. **AdMob Setup**
   - Replace test IDs with your real AdMob IDs
   - Configure `AndroidManifest.xml` and `Info.plist`

2. **App Icons**
   - Replace default icons with branded icons
   - Use https://appicon.co/ for generation

3. **Build for Release**
   ```bash
   flutter build appbundle --release  # For Play Store
   ```

4. **Platform Configuration**
   - Android: Update `AndroidManifest.xml`
   - iOS: Update `Info.plist`

### What Works Offline (100%)
- ✅ All core features
- ✅ Health tracking & assessments
- ✅ Biological age calculations
- ✅ Coaching & recommendations
- ✅ Data visualization
- ✅ Profile management
- ✅ Local notifications

### What Requires Internet (Optional)
- 🌐 AdMob banner ads (monetization)
- 🌐 Google Fit sync (optional feature)
- 🌐 Apple Health sync (optional feature)

---

## 💡 Key Features Explained

### 1. Biological Age Assessment
- **Evidence-based algorithm** calculating biological age from 5 health categories
- **Nutrition scoring**: Diet quality, vegetable intake, processed food frequency
- **Exercise scoring**: Weekly activity, HIIT sessions, strength training, daily steps
- **Sleep scoring**: Duration, quality, consistency, bedtime habits
- **Stress scoring**: Perceived stress, meditation, work-life balance
- **Social scoring**: Social connections and support (baseline)

### 2. Wearable Integration
- **Automatic data sync** from Google Fit (Android) or Apple Health (iOS)
- **Synced metrics**: Steps, active calories, sleep hours, workout minutes
- **Privacy-first**: Only reads data, never writes to health apps
- **Optional feature**: Users choose whether to enable

### 3. Data Export
- **JSON format**: Complete data dump (profile + assessments + tracking)
- **CSV tracking**: Daily tracking data in spreadsheet format
- **CSV assessments**: Assessment history with category scores
- **Clipboard copy**: Easy sharing and backup

### 4. AdMob Monetization
- **Banner ads** displayed at bottom of main screen
- **Non-intrusive**: Positioned above navigation bar
- **Test IDs included**: Ready to replace with your real IDs
- **Production-ready**: Fully integrated and tested

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is private and not published to pub.dev.

---

## 🆘 Support

For issues and questions:
- 📧 Open an issue in the GitHub repository
- 📖 Check [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md) for deployment help

---

## 🎉 Achievements

- ✅ **100% offline-first** - No internet required
- ✅ **Privacy-focused** - All data stays on device
- ✅ **Production-ready** - Fully tested and deployment-ready
- ✅ **Monetization-ready** - AdMob integrated
- ✅ **Feature-complete** - All planned features implemented
- ✅ **Well-documented** - Comprehensive guides and comments
- ✅ **Clean architecture** - Maintainable and scalable code

---

<div align="center">

**Built with Flutter and ❤️ for health optimization**

⭐ Star this repo if you find it useful!

</div>
