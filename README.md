# goritmi_task

A new Flutter project for task management.

## Getting Started

Follow these steps to set up and run the project locally.

### Prerequisites

Make sure you have the following installed on your system:

- Flutter SDK: [Install Flutter](https://docs.flutter.dev/get-started/install)
- Android Studio or Visual Studio Code with Flutter and Dart plugins
- A connected device or an Android/iOS emulator for testing

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-link>
   cd goritmi_task
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

### Configuration

### Features

- Add, delete, and update tasks
- Filter and sort tasks
- Persistent task storage using SQLite
- Notification permissions using `permission_handler`
- Guided user tutorial using `tutorial_coach_mark`

### Permissions

This app requests notification permissions. If the permission is denied, you can enable it manually from the device settings.

### APK Generation

To generate the APK:
1. Run the following command:
   ```bash
   flutter build apk --release
   ```
2. The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`.


## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online Documentation](https://docs.flutter.dev/)
