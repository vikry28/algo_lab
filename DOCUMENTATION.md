# 📚 Algo Lab Pro - Documentation

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.10.0+-02569B?logo=flutter)
![Provider](https://img.shields.io/badge/State%20Management-Provider-green)
![Firebase](https://img.shields.io/badge/Backend-Firebase-orange?logo=firebase)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 Overview

**Algo Lab Pro** is an interactive mobile application designed to help users master algorithms through real-world data visualization and hands-on learning. The app provides comprehensive learning modules, interactive code editors, visualizations, and gamification features to make algorithm learning engaging and effective.

### ✨ Key Features

- 🎨 **Interactive Visualizations** - Real-time algorithm execution with step-by-step visualization
- 📖 **Comprehensive Learning Modules** - Detailed explanations, code examples, and quizzes
- 🔬 **Algorithm Labs** - Hands-on experimentation with sorting, pathfinding, and cryptography
- 🏆 **Gamification** - XP system, achievements, badges, and streak tracking
- 🌍 **Multi-language Support** - English and Indonesian localization
- 🔐 **Authentication** - Google Sign-In and Quick Login with Firebase
- 📊 **Progress Tracking** - Detailed analytics and learning history
- 🎯 **Clean Architecture** - Modular, testable, and maintainable codebase

---

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── core/                    # Core utilities and shared components
│   ├── constants/          # App-wide constants (colors, typography, routes)
│   ├── di/                 # Dependency injection (Service Locator)
│   ├── services/           # Core services (Auth, Firestore, Analytics)
│   └── utils/              # Utility functions and helpers
│
├── features/               # Feature modules (Clean Architecture)
│   ├── home/
│   │   ├── data/          # Data sources, models, repositories
│   │   ├── domain/        # Entities, use cases, repository interfaces
│   │   └── presentation/  # UI (views, widgets, providers)
│   │
│   ├── learning/          # Learning modules and progress tracking
│   ├── sorting_lab/       # Sorting algorithm visualizations
│   ├── cryptography_lab/  # RSA encryption lab
│   ├── pathfinding/       # A* pathfinding visualization
│   ├── profile/           # User profile and settings
│   ├── onboarding/        # Onboarding flow
│   └── splash/            # Splash screen
│
└── app_shell.dart         # App initialization and routing
```

### State Management

The app uses **Provider** for state management with the following pattern:

- **ChangeNotifier** - For reactive state updates
- **Consumer/Provider.of** - For accessing state in widgets
- **MultiProvider** - For providing multiple providers
- **Dependency Injection** - Using GetIt for service locator pattern

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `^3.38.2`
- Dart SDK: `^3.10.0`
- Firebase Project (for authentication and database)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/algo_lab.git
   cd algo_lab
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders
   - Enable Authentication (Google Sign-In, Anonymous)
   - Enable Firestore Database
   - Enable Firebase Analytics

4. **Configure Environment Variables**
   
   Create a `.env` file in the root directory:
   ```env
   # Firebase Configuration
   FIREBASE_API_KEY=your_api_key
   FIREBASE_APP_ID=your_app_id
   FIREBASE_MESSAGING_SENDER_ID=your_sender_id
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_STORAGE_BUCKET=your_storage_bucket
   
   # Google Sign-In
   GOOGLE_CLIENT_ID=your_google_client_id
   ```

5. **Generate code (for envied and mocks)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_screenutil` | ^5.9.3 | Responsive UI scaling |
| `provider` | ^6.1.5 | State management |
| `go_router` | ^17.0.0 | Navigation and routing |
| `get_it` | ^9.2.0 | Dependency injection |
| `shared_preferences` | ^2.5.3 | Local storage |
| `google_fonts` | ^6.3.3 | Custom fonts |

### Firebase

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | ^4.3.0 | Firebase initialization |
| `firebase_auth` | ^6.1.3 | Authentication |
| `cloud_firestore` | any | Database |
| `firebase_analytics` | ^12.1.0 | Analytics tracking |
| `firebase_storage` | ^13.0.1 | File storage |
| `firebase_messaging` | ^16.1.0 | Push notifications |

### UI/UX

| Package | Version | Purpose |
|---------|---------|---------|
| `cached_network_image` | 3.4.1 | Image caching |
| `shimmer` | 3.0.0 | Loading animations |
| `flutter_svg` | ^2.0.10 | SVG support |
| `line_icons` | ^2.0.3 | Icon library |

### Authentication & Security

| Package | Version | Purpose |
|---------|---------|---------|
| `google_sign_in` | ^7.2.0 | Google authentication |
| `local_auth` | ^3.0.0 | Biometric authentication |
| `envied` | ^1.2.0 | Environment variables |

### Development

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | sdk | Testing framework |
| `mockito` | ^5.4.5 | Mocking for tests |
| `build_runner` | ^2.4.15 | Code generation |
| `flutter_lints` | ^6.0.0 | Linting rules |

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/sorting_lab/domain/usecases/sorting_usecase_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Structure

```
test/
├── core/
│   └── services/          # Service tests
│       ├── auth_service_test.dart
│       └── firestore_service_test.dart
│
├── features/
│   ├── sorting_lab/       # Sorting algorithm tests
│   ├── cryptography_lab/  # RSA encryption tests
│   ├── pathfinding/       # A* pathfinding tests
│   ├── home/              # Home feature tests
│   ├── learning/          # Learning provider tests
│   ├── onboarding/        # Onboarding tests
│   └── profile/           # Profile tests
│
├── integration/           # Integration tests
└── widget_test.dart       # Widget smoke tests
```

### Test Coverage

- ✅ **105 Unit Tests** - All passing
- ✅ **Core Services** - Auth, Firestore
- ✅ **Use Cases** - All sorting, pathfinding, cryptography use cases
- ✅ **Providers** - State management logic
- ✅ **Repositories** - Data layer

---

## 🎨 Features Deep Dive

### 1. **Home Screen**
- Algorithm catalog with search and filtering
- Category-based navigation (Sorting, Graph, Search, Cryptography)
- Learning progress summary
- Quick access to popular modules

### 2. **Learning Modules**
Each algorithm includes:
- 📖 **Introduction** - Overview and use cases
- 🔍 **Understanding** - How it works
- 📝 **Algorithm Steps** - Step-by-step breakdown
- ⏱️ **Complexity Analysis** - Time and space complexity
- 💡 **Advantages & Disadvantages**
- 🎯 **Real-world Examples**
- 💻 **Code Implementation** - Interactive code editor
- ✅ **Quizzes** - Coding challenges with validation

**Supported Algorithms:**
- **Sorting:** Bubble, Selection, Insertion, Quick, Merge, Heap
- **Search:** Linear, Binary, Interpolation
- **Graph:** BFS, DFS, Dijkstra, Bellman-Ford, Floyd-Warshall, Kruskal, Prim
- **Cryptography:** Caesar, Vigenere, RSA, AES, SHA-256
- **Pathfinding:** A* Algorithm

### 3. **Algorithm Labs**

#### Sorting Lab
- Interactive visualization of sorting algorithms
- Real-time comparison and swap tracking
- Adjustable animation speed
- Case studies with real-world data

#### Cryptography Lab (RSA)
- Key generation visualization
- Step-by-step encryption/decryption
- Interactive message input
- Mathematical breakdown

#### Pathfinding Lab (A*)
- Grid-based pathfinding visualization
- Obstacle placement and weights
- Multiple heuristic options (Manhattan, Euclidean, Chebyshev)
- Logistics optimization case study

### 4. **Gamification System**

#### XP & Levels
- Earn XP by completing modules and quizzes
- Level progression system
- Daily XP tracking

#### Achievements & Badges
- 🏆 **Algo Novice** - Reach 100 XP
- 🎓 **Algo Master** - Complete 50 algorithms
- ⚡ **Speed Demon** - Solve in under 30 seconds
- 🔥 **Streak Hero** - Maintain 7-day streak
- 👨‍🏫 **Mentor** - Help 5 learners

#### Progress Tracking
- Module completion percentage
- Streak tracking
- Learning history
- Global ranking (Top 1%, 5%, 10%, 25%)

### 5. **Profile & Settings**

- **Account Management**
  - Edit profile (name, photo)
  - Security settings (password, 2FA)
  - Biometric authentication

- **Progress Summary**
  - Total algorithms completed
  - Total XP earned
  - Current streak
  - Level progression

- **Achievements**
  - Badge collection
  - Latest achievements
  - Unlock progress

- **Settings**
  - Language selection (EN/ID)
  - Notification preferences
  - Theme customization

### 6. **Authentication**

- **Google Sign-In** - OAuth 2.0 authentication
- **Quick Login** - Anonymous authentication for quick access
- **Profile Sync** - Automatic Firestore synchronization
- **Logout** - Secure sign-out with data cleanup

---

## 🌍 Localization

The app supports **English** and **Indonesian** with 840+ translation keys.

### Adding a New Language

1. Create a new JSON file in `assets/localization/`:
   ```
   assets/localization/es.json  # Spanish
   ```

2. Copy the structure from `en.json` and translate all values

3. Update `AppLocalizations` to support the new locale

4. Add the locale to `MaterialApp`:
   ```dart
   supportedLocales: [
     Locale('en'),
     Locale('id'),
     Locale('es'),  // New language
   ]
   ```

---

## 🔥 Firebase Configuration

### Firestore Structure

```
users/
  {userId}/
    - uid: string
    - email: string
    - displayName: string
    - photoURL: string
    - totalXP: number
    - streak: number
    - lastLearnDate: string
    - completedModules: array
    - badges: array
    
    progress/
      {moduleId}/
        - moduleId: string
        - progress: number (0.0 - 1.0)
        - completed: boolean
        - lastAccessed: timestamp
```

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /progress/{moduleId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

---

## 🎯 Code Style & Best Practices

### Naming Conventions

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Variables/Functions:** `camelCase`
- **Constants:** `SCREAMING_SNAKE_CASE`
- **Private members:** `_leadingUnderscore`

### Code Organization

```dart
// 1. Imports (sorted)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Constants
  static const double padding = 16.0;
  
  // 4. Fields
  final String title;
  
  // 5. Constructor
  const MyWidget({super.key, required this.title});
  
  // 6. Lifecycle methods
  @override
  Widget build(BuildContext context) {
    // ...
  }
  
  // 7. Private methods
  void _handleTap() {
    // ...
  }
}
```

### Provider Pattern

```dart
// 1. Define ChangeNotifier
class MyProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// 2. Provide at app level
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MyProvider()),
  ],
  child: MyApp(),
)

// 3. Consume in widgets
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text('${provider.count}');
  },
)
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **Firebase initialization error**
```
Solution: Ensure google-services.json is in android/app/
and GoogleService-Info.plist is in ios/Runner/
```

#### 2. **Build runner fails**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. **Google Sign-In not working**
```
Solution: 
1. Check SHA-1 fingerprint in Firebase Console
2. Verify google-services.json is up to date
3. Enable Google Sign-In in Firebase Authentication
```

#### 4. **Localization not loading**
```
Solution: Run flutter pub get and restart the app
Ensure JSON files are in assets/localization/
```

---

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Supported | Min SDK: 21 (Android 5.0) |
| iOS | ✅ Supported | Min iOS: 12.0 |
| Web | ⚠️ Partial | Limited Firebase features |
| Windows | ⚠️ Partial | No biometric auth |
| macOS | ⚠️ Partial | No biometric auth |
| Linux | ⚠️ Partial | No biometric auth |

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style
- Write unit tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Vikry28** - *Initial work* - [GitHub](https://github.com/vikry28)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google Fonts for typography
- Line Icons for beautiful icons
- All contributors and testers

---

## 📞 Support

For support, email support@algolab.com or join our Slack channel.

---

## 🗺️ Roadmap

### Version 1.1.0
- [ ] More algorithm visualizations (Heap Sort, AVL Tree)
- [ ] Dark mode support
- [ ] Offline mode with local caching
- [ ] Social features (leaderboards, sharing)

### Version 1.2.0
- [ ] AI-powered hints and explanations
- [ ] Video tutorials
- [ ] Community challenges
- [ ] Custom algorithm creation

---

**Made with ❤️ using Flutter**
