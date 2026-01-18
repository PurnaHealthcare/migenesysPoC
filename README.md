# MiGenesys PoC 💙🌱

MiGenesys is a modern healthcare application designed to empower users in managing their health journey. Built with a focus on ease of use, security, and a premium aesthetic, it provides a comprehensive suite of tools for health monitoring, medication management, and medical record organization.

## 🚀 Key Features

- **Secure Authentication**: Robust user login and security.
- **Health Journey & Onboarding**: Personalized onboarding experience to guide users through their health goals.
- **Medication Management**: Track medications, dosages, and schedules with ease.
- **Health Reports (OCR)**: Digitalize paper medical reports using advanced OCR technology.
- **Medical Timeline**: A visual history of health events, doctor visits, and milestones.
- **Profile Management**: Maintain personal health metrics and emergency information.

## 🛠 Tech Stack

- **Frontend**: Flutter (Sdk: ^3.10.4)
- **State Management**: Riverpod
- **Architecture**: MVVM (Model-View-ViewModel)
- **Middle Layer**: Node.js (`migenesys-nucleus`)
- **Backend Patterns**: CQRS (Command Query Responsibility Segregation)

## 📁 Project Structure

```text
.
├── lib/                        # Flutter frontend source code
│   ├── core/                   # Core utilities, services, and design system
│   └── features/               # Feature-based modules (auth, medication, etc.)
├── migenesys-nucleus/          # Node.js middle layer (Commands, Queries, Models)
├── test/                       # Unit and widget tests
└── ios/ android/               # Platform-specific configurations
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

#### **iOS Simulator**
If you have an iOS simulator open, you can run the app directly:
```bash
flutter run -d <IOS_DEVICE_ID>
```
*Tip: Open the iOS Simulator using `open -a Simulator`.*

#### **Android Emulator**
If you have an Android Virtual Device (AVD) open:
```bash
flutter run -d <ANDROID_DEVICE_ID>
```

#### **Web (Chrome)**
To run the app in Chrome:
```bash
flutter run -d chrome
```

### 3. Running on Multiple Platforms

**Important**: Flutter does not support running on all platforms simultaneously with a single command. The `flutter run -d all` command will fail with an error.

To test on multiple platforms, you need to run each platform in a **separate terminal session**:

**Terminal 1 - iOS:**
```bash
flutter run -d "iPhone 16e"  # Replace with your device ID
```

**Terminal 2 - Android:**
```bash
flutter run -d "sdk gphone64 arm64"  # Replace with your device ID
```

**Terminal 3 - Web:**
```bash
flutter run -d chrome
```

Each instance will run independently, allowing you to test the app across platforms simultaneously.

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
