# Fintechnic E-wallet App

## Overview
Fintechnic is a comprehensive mobile banking application that provides users with a seamless digital banking experience. The app allows users to manage their finances, perform transactions and access various banking services securely from their mobile devices.

## Features
- **Account Management**: View balances and transaction history
- **Money Transfers**: Send and receive money securely
- **Transaction Analytics**: Visualize spending patterns with charts
- **Secure Storage**: Encrypted data storage for sensitive information

## Tech Stack
- **Frontend**: Flutter (Cross-platform mobile development)
- **Backend**: Spring Boot
- **Database**: PostgreSQL
- **Authentication**: Biometric and token-based authentication
- **API**: RESTful services with Retrofit
- **State Management**: Provider pattern

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / XCode
- JDK 11 or higher (for Spring Boot backend)
- PostgreSQL
- Already clone backend server repository
```bash
git clone https://github.com/Fintechnic/Fintechnic_banking_backend.git
```

### Database setup
- Create a database named "fintechnic"

### Installation
1. Clone the repository:
```bash
git clone https://github.com/yourusername/Mobile-banking-app.git
cd Mobile-banking-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create environment configuration:
   - Replace API host and API URL to fit your system environment in `.env.development`
   - Update the necessary API endpoints and configuration

4. Run the app:
```bash
flutter run
```
Note: Backend server need to run at the same time with application to work.

## Project Structure
- `lib/`: Contains all the Dart code for the application
  - `main.dart`: Entry point of the application
  - `screens/`: UI screens of the application
  - `models/`: Data models
  - `services/`: API and local services
  - `providers/`: State management
  - `utils/`: Utility functions and constants

## Testing
Run tests with:
```bash
flutter test
```

## Deployment
### Android
```bash
flutter build apk --release
```

## Credit
- Le Minh Viet: https://github.com/Kaso45
- Tran Nguyen Thien An: https://github.com/andythienan
- Nguyen Vo Chi Dung: https://github.com/NZodasic
- Do Nhu Quan: https://github.com/nhuquan223
- Nguyen Dien Duy Anh: https://github.com/tomngyx
