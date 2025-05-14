# Flexy - A Modern Android Cashier and Inventory Management Application

Flexy is a sophisticated Android application designed to streamline cashier operations and inventory management for small to medium-sized businesses. With a focus on efficiency and user experience, Flexy provides a comprehensive solution for managing transactions, tracking inventory, and generating financial insights, all within a secure and intuitive mobile interface.

## Features

- 🔐 **User Authentication**: Secure login system to ensure only authorized users can access the application.
- 📦 **Ticket and Inventory Management**: Easily manage tickets and track inventory with a user-friendly interface.
- 📊 **User Dashboard with Revenue Insights**: A centralized dashboard displaying total accumulated revenue for quick financial overview.
- 🧮 **Cashier Calculation**: Automated calculation tools to simplify cashier operations and reduce errors.
- 💵 **Cash Payment Processing**: Seamless handling of cash transactions for a smooth checkout experience.
- 🖨️ **Receipt Printing**: Generate and print receipts for every transaction, ensuring proper documentation.
- 📜 **Purchase History**: Comprehensive history of all purchases for auditing and customer reference.
- 📱 **Android-Optimized**: Fully optimized for Android devices, ensuring a responsive and native experience.

## Tech Stack

- **Mobile Framework**: Flutter 3.29.2
- **Backend Language**: Java 17
- **Platform**: Android-specific
- **State Management**: Provider (commonly used in Flutter for state management)
- **Database**: SQLite (default for Flutter mobile apps)
- **Styling**: Material Design with custom theming

## Getting Started

### Prerequisites

- Flutter 3.29.2 (ensure the Flutter SDK is installed)
- Java 17 (JDK for Android development)
- Android Studio or VS Code with Flutter/Dart plugins
- Android emulator or physical Android device (API 21 or higher)
- Git

### Installation

1. **Clone the Repository**  
   Clone the Flexy repository and navigate to the project directory:
   ```bash
   git clone https://github.com/hanifaslam/appflexy.git
   cd appflexy
   ```

2. **Install Dependencies**  
   Install the required Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. **Run the Application**  
   Launch the app on an emulator or physical Android device:
   ```bash
   flutter run
   ```

## Project Structure

The project follows a standard Flutter structure for better organization and scalability:

```plaintext
├── ios/                 # iOS-specific files (not used for this Android project)
├── lib/                 # Main Dart source code
│   ├── models/          # Data models for the application
│   ├── modules/         # Feature-specific modules (e.g., authentication, tickets)
│   ├── routes/          # Navigation routes for the app
│   ├── widgets/         # Reusable UI widgets
│   └── main.dart        # Entry point of the application
├── linux/               # Linux-specific files (not used for this project)
├── macos/               # macOS-specific files (not used for this project)
├── test/                # Unit and widget tests
└── pubspec.yaml         # Flutter dependencies and configuration
```

## Running Tests

To ensure the application works as expected, run the test suite:
```bash
flutter test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Flutter](https://flutter.dev) - The mobile framework
- [Dart](https://dart.dev) - The programming language
- [Material Design](https://material.io) - Design system for UI components

## About This Project

This project was developed to fulfill the Project-Based Learning (PBL) assignment at our college, encompassing various courses and promoting practical skills in mobile application development, version control, and collaborative workflows.