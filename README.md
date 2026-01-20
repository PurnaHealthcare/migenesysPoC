# MiGenesys PoC 💙🌱

MiGenesys is a modern healthcare platform consisting of multiple specialized applications designed to serve different stakeholders in the healthcare ecosystem. Built with Flutter for cross-platform deployment.

## 🏥 Platform Apps

| App | Target Audience | Entry Point | Description |
|-----|-----------------|-------------|-------------|
| **MiGenesys Life** | Consumers | `main_life.dart` | Personal health management, medication tracking, medical records |
| **MiGenesys Care** | Healthcare Orgs | `main_care.dart` | Organization dashboard, staff management, patient directory, scheduling |
| **MiGenesys Partner** | Partners | `main_partner.dart` | Partner portal for healthcare ecosystem integration |
| **DocAssist** | Clinicians | `main_docassist.dart` | AI-powered clinical documentation and decision support |

## 🚀 Key Features

### MiGenesys Life (Consumer App)
- **Secure Authentication**: Robust user login and security
- **Health Journey & Onboarding**: Personalized onboarding experience
- **Medication Management**: Track medications, dosages, and schedules
- **Health Reports (OCR)**: Digitalize paper medical reports
- **Medical Timeline**: Visual history of health events

### MiGenesys Care (Healthcare Dashboard)
- **Role-Based Access Control**: Service staff vs. medical professional routing
- **Organization Dashboard**: KPIs, scores, and critical alerts
- **Staff Management**: Add, view, and manage healthcare staff
- **Patient Directory**: Searchable patient records with RBAC
- **Provider Scheduling**: Multi-specialty filtering and availability calendar
- **Analytics & Audit Logging**: PHI access tracking and compliance

## 🛠 Tech Stack

- **Frontend**: Flutter (Sdk: ^3.10.4)
- **State Management**: Riverpod (FutureProviders, ConsumerWidgets)
- **Architecture**: Clean Architecture with Repository Pattern
- **Middle Layer**: Node.js (`migenesys-nucleus`)
- **Backend Patterns**: CQRS (Command Query Responsibility Segregation)

## 📁 Project Structure

```text
.
├── lib/                        # Flutter frontend source code
│   ├── app/                    # App entry points
│   │   ├── app_life.dart       # MiGenesys Life (Consumer App)
│   │   ├── app_care.dart       # MiGenesys Care (Healthcare Dashboard)
│   │   ├── app_partner.dart    # MiGenesys Partner (Partner Portal)
│   │   └── app_docassist.dart  # DocAssist (Clinical AI)
│   ├── core/                   # Core utilities, services, and design system
│   │   ├── repositories/       # Data access layer (Clean Architecture)
│   │   ├── analytics/          # Analytics service
│   │   ├── data/               # Mock data
│   │   └── theme/              # App themes
│   ├── features/               # Feature-based modules
│   │   ├── auth/               # Authentication
│   │   ├── org_dashboard/      # Care app dashboard
│   │   │   ├── domain/         # Domain models
│   │   │   ├── view/           # UI screens
│   │   │   └── view_model/     # Riverpod providers
│   │   └── ...                 # Other features
│   ├── main_life.dart          # Entry point: MiGenesys Life
│   ├── main_care.dart          # Entry point: MiGenesys Care
│   ├── main_partner.dart       # Entry point: MiGenesys Partner
│   └── main_docassist.dart     # Entry point: DocAssist
├── test/                       # Unit and widget tests
├── migenesys-nucleus/          # Node.js middle layer (CQRS)
└── ios/ android/ web/          # Platform-specific configurations
```

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/) (v16+)
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) (for iOS development)

### Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd MiGenesys-PoC
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Install Middle Layer dependencies**:
   ```bash
   cd migenesys-nucleus
   npm install
   ```

## 📱 Running with Simulators

To run the application on a mobile simulator or emulator, follow these steps:

### 1. List Available Devices
Check which simulators/emulators are currently available:
```bash
flutter devices
```

### 2. Launch the Application

The MiGenesys platform consists of multiple apps. Use the `--target` flag to launch specific apps:

#### **MiGenesys Life** (Consumer Health App)
```bash
flutter run --target=lib/main_life.dart
```

#### **MiGenesys Care** (Healthcare Organization Dashboard)
```bash
flutter run --target=lib/main_care.dart
```

#### **MiGenesys Partner** (Partner Portal)
```bash
flutter run --target=lib/main_partner.dart
```

#### **MiGenesys DocAssist** (Clinical Documentation AI)
```bash
flutter run --target=lib/main_docassist.dart
```

#### **Default App** (MiGenesys Life)
```bash
flutter run
```

### 3. Platform-Specific Launch

#### **iOS Simulator**
```bash
# Open iOS Simulator first
open -a Simulator

# List available iOS devices
flutter devices

# Run MiGenesys Care on iOS
flutter run --target=lib/main_care.dart -d "iPhone 16"

# Run MiGenesys Life on iOS  
flutter run --target=lib/main_life.dart -d "iPhone 16 Pro"
```

#### **Android Emulator**
```bash
# List available Android devices
flutter devices

# Run MiGenesys Care on Android
flutter run --target=lib/main_care.dart -d "emulator-5554"

# Run MiGenesys Life on Android
flutter run --target=lib/main_life.dart -d "sdk gphone64 arm64"
```

#### **Physical Devices**
```bash
# iOS device (requires signing)
flutter run --target=lib/main_care.dart -d <DEVICE_UDID>

# Android device (enable USB debugging)
flutter run --target=lib/main_care.dart -d <DEVICE_ID>
```

#### **Web (Chrome)**
```bash
flutter run --target=lib/main_care.dart -d chrome
```

### 4. Building for Production

#### **Web Builds**
```bash
flutter build web --target=lib/main_life.dart
flutter build web --target=lib/main_care.dart
flutter build web --target=lib/main_partner.dart
flutter build web --target=lib/main_docassist.dart
```

#### **iOS Builds**
```bash
# Debug build
flutter build ios --target=lib/main_care.dart --debug

# Release build (requires signing)
flutter build ios --target=lib/main_care.dart --release

# Build IPA for distribution
flutter build ipa --target=lib/main_care.dart
```

#### **Android Builds**
```bash
# Debug APK
flutter build apk --target=lib/main_care.dart --debug

# Release APK
flutter build apk --target=lib/main_care.dart --release

# App Bundle for Play Store
flutter build appbundle --target=lib/main_care.dart
```

### 5. Running on Multiple Platforms

**Important**: Flutter does not support running on all platforms simultaneously with a single command.

To test on multiple platforms, run each in a **separate terminal session**:

**Terminal 1 - iOS (MiGenesys Care):**
```bash
flutter run --target=lib/main_care.dart -d "iPhone 16e"
```

**Terminal 2 - Android (MiGenesys Care):**
```bash
flutter run --target=lib/main_care.dart -d "sdk gphone64 arm64"
```

**Terminal 3 - Web (MiGenesys Life):**
```bash
flutter run --target=lib/main_life.dart -d chrome
```

## 🧪 Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/repository_test.dart

# Run with coverage
flutter test --coverage
```

**Current Test Status: 44 tests passing**

| Test Category | Count | Description |
|--------------|-------|-------------|
| Repository Tests | 20 | Patient, Staff, Dashboard, Availability |
| Model Tests | 11 | Serialization, factories, edge cases |
| Integration Tests | 13 | App smoke, RBAC, analytics, workflows |

## 🏗 Middle Layer (`migenesys-nucleus`)

The `migenesys-nucleus` serves as the logic core, implementing the **CQRS** pattern to handle complex health data operations efficiently. It is built with TypeScript and designed to be platform-agnostic, allowing the core logic to be shared or moved across services if needed.

### 🏁 Setup & Development

1. **Navigate to the directory**:
   ```bash
   cd migenesys-nucleus
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Verify Types & Compilation**:
   To ensure the TypeScript code is valid and compile it:
   ```bash
   npx tsc
   ```

4. **Project Logic**:
   - **Commands** (`src/commands`): Define state-changing actions (e.g., `StartJourney`).
   - **Queries** (`src/queries`): Define data retrieval logic.
   - **Models** (`src/models`): Shared domain entities.
   - **Events** (`src/events`): Domain events triggered by commands.

### 🧪 Running Tests
Once test suites are implemented, you can run them using:
```bash
npm test
```

---
*Built with care by the MiGenesys Team.*
