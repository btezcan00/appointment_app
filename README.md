# Appointment App

A Flutter application for booking and managing medical appointments with Firebase backend.

## Features

### 1. User Authentication
- Email/password authentication
- Anonymous sign-in support
- Secure Firebase Authentication integration

### 2. Profile Management
- View user profile information (name, age, email, phone, address)
- **Edit Profile**: Users can update their profile details through a dedicated edit screen
- Profile data synced with Firebase Firestore
- Real-time profile updates

### 3. Appointment Booking
- Browse available doctors and specialties
- Book appointments with preferred doctors
- Select appointment date and time
- Choose appointment location

### 4. My Appointments
- View all booked appointments
- Track appointment status (Pending, Confirmed, Cancelled)
- Real-time appointment updates via Firestore streams

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── appointment.dart         # Appointment data model
│   └── user_profile.dart        # User profile data model
├── pages/
│   ├── auth_page.dart           # Authentication screen
│   ├── book_appointment_page.dart # Appointment booking screen
│   ├── edit_profile_page.dart   # Profile editing screen
│   ├── my_appointments_page.dart # Appointments list screen
│   └── profile_page.dart        # User profile display screen
├── services/
│   └── firebase_service.dart    # Firebase integration service
└── data/
    └── placeholder_data.dart    # Sample data for development
```

## Firebase Setup

### Prerequisites
1. Firebase project with the following enabled:
   - Firebase Authentication (Email/Password provider)
   - Cloud Firestore

### Firestore Database Structure

#### Collections

**users**
```json
{
  "userId": {
    "name": "string",
    "age": "number",
    "email": "string",
    "phone": "string",
    "address": "string",
    "profilePhotoUrl": "string",
    "updatedAt": "timestamp"
  }
}
```

**appointments**
```json
{
  "appointmentId": {
    "userId": "string",
    "doctorName": "string",
    "specialty": "string",
    "dateTime": "timestamp",
    "location": "string",
    "status": "string",
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
}
```

**doctors**
```json
{
  "doctorId": {
    "name": "string"
  }
}
```

**specialties**
```json
{
  "specialtyId": {
    "name": "string"
  }
}
```

### Required Firestore Indexes

Create a composite index for appointments:
- Collection: `appointments`
- Fields: `userId` (Ascending), `dateTime` (Ascending)

## Getting Started

### Installation

1. Clone the repository
```bash
git clone https://github.com/btezcan00/appointment_app.git
cd appointment_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Follow the instructions in `FIREBASE_SETUP.md`
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

4. Run the app
```bash
flutter run
```

### Running Tests

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/edit_profile_test.dart
```

## Features Documentation

### Edit Profile

The Edit Profile feature allows users to update their personal information:

**Accessible from**: Profile tab → "Edit Profile" button

**Editable Fields**:
- Full Name (required, minimum 2 characters)
- Age (required, 1-150)
- Email (optional, must be valid email format)
- Phone (optional, minimum 10 digits)
- Address (optional, multi-line text)

**Implementation Details**:
- File: `lib/pages/edit_profile_page.dart`
- Form validation with real-time error messages
- Disabled save button while saving to prevent duplicate submissions
- Success/error feedback via SnackBar
- Automatic profile refresh on successful update
- Profile data stored in Firestore `users` collection

**Testing**:
- Test file: `test/edit_profile_test.dart`
- 13 widget tests covering UI rendering and user interactions
- All tests passing ✓

## Development

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Firebase CLI (for deployment)
- iOS Simulator / Android Emulator or physical device

### Dependencies
- `firebase_core`: Firebase SDK initialization
- `firebase_auth`: User authentication
- `cloud_firestore`: Cloud database
- `intl`: Date formatting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.
