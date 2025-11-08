# AgeLess - Biological Age Reversal

A comprehensive Flutter application designed to help users track and reverse their biological age through personalized health interventions, progress tracking, and AI-powered coaching.

## Overview

AgeLess is a mobile and desktop application that enables users to:
- Track their biological age and health metrics
- Receive personalized coaching and recommendations
- Monitor progress over time with detailed analytics
- Complete health assessments
- Unlock achievements as they improve their health
- Manage their wellness journey with local data storage

## Features

### Core Features
- **Dashboard** - Overview of health metrics and key insights
- **Progress Tracking** - Monitor changes in biological age and health markers
- **Health Assessment** - Comprehensive health evaluations
- **AI Coaching** - Personalized recommendations and guidance
- **Achievements System** - Gamified progress tracking
- **User Profile** - Manage personal information and preferences
- **Onboarding** - Smooth introduction to the app's features

### Technical Features
- **Offline-First** - Local data storage with Hive
- **Beautiful Charts** - Visual progress tracking with fl_chart
- **Smart Notifications** - Reminders and health tips
- **Cross-Platform** - Supports Android, iOS, Web, Windows, macOS, and Linux
- **Dark Mode** - System-aware theme switching
- **Modern Architecture** - Clean architecture with domain-driven design

## Technology Stack

- **Framework**: Flutter 3.4.0+
- **State Management**: Riverpod 2.5.1
- **Routing**: GoRouter 16.2.4
- **Local Storage**: Hive 2.2.3
- **Charts**: FL Chart 1.1.1
- **Notifications**: Flutter Local Notifications 19.4.2
- **Fonts**: Google Fonts 6.2.1
- **Date/Time**: Intl 0.20.2 & Timezone 0.10.1

## Project Structure

```
lib/
├── core/               # Core utilities and configuration
│   ├── constants/      # App-wide constants
│   ├── router/         # Navigation and routing
│   ├── theme/          # App theming
│   └── utils/          # Helper utilities
├── data/               # Data layer
│   └── local/          # Local storage configuration
├── domain/             # Business logic layer
│   └── services/       # Business services
└── presentation/       # UI layer
    ├── providers/      # Riverpod state providers
    └── screens/        # UI screens
```

## Getting Started

### Prerequisites

- Flutter SDK 3.4.0 or higher
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio with Flutter plugins

### Installation

1. Clone the repository:
```bash
git clone https://github.com/kashifumair125/Age-Less.git
cd Age-Less
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation for Hive:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: Latest

#### iOS
- Minimum iOS version: 12.0
- Requires Xcode for development

#### Web
```bash
flutter run -d chrome
```

#### Desktop (Windows/macOS/Linux)
```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

## Development

### Running Tests
```bash
flutter test
```

### Code Generation
When you modify Hive models, regenerate adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build for Production

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## Architecture

This project follows Clean Architecture principles:

- **Presentation Layer**: UI components and state management (Riverpod)
- **Domain Layer**: Business logic and services
- **Data Layer**: Data sources and repositories (Hive for local storage)

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing |
| `hive` & `hive_flutter` | Local NoSQL database |
| `fl_chart` | Beautiful charts and graphs |
| `flutter_local_notifications` | Push notifications |
| `google_fonts` | Custom fonts |
| `percent_indicator` | Progress indicators |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is private and not published to pub.dev.

## Support

For issues and questions, please open an issue in the GitHub repository.

---

Built with Flutter and ❤️ for health optimization
