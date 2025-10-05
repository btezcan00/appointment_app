# Firebase Setup for Appointment App

This app now uses Firebase for authentication and data storage instead of placeholder data.

## Features Implemented

### 1. Firebase Authentication
- **Email/Password Authentication**: Users can sign up and sign in with email and password
- **Anonymous Authentication**: Users can continue as a guest without creating an account
- **Auth State Management**: Automatic routing between auth and home screens based on authentication state
- **Logout Functionality**: Users can sign out from the profile page

### 2. Cloud Firestore Integration
- **User Profiles**: User data is stored in Firestore (`users` collection)
  - Fields: name, age, profilePhotoUrl, email, phone, address
- **Appointments**: Appointments are stored per user in Firestore (`appointments` collection)
  - Fields: userId, doctorName, specialty, dateTime, location, status, createdAt
  - Real-time updates using Firestore streams
- **Doctors & Specialties**: Configurable lists stored in Firestore
  - Collections: `doctors` and `specialties`
  - Falls back to default values if not configured in Firestore

## Firebase Configuration

The app uses the project ID from your `firebase-key.json`: **rugged-scion-288306**

### Firebase Collections Structure

#### users/{userId}
```json
{
  "name": "John Doe",
  "age": 35,
  "profilePhotoUrl": "",
  "email": "john.doe@example.com",
  "phone": "+1 (555) 123-4567",
  "address": "123 Main St, New York, NY 10001",
  "updatedAt": "timestamp"
}
```

#### appointments/{appointmentId}
```json
{
  "userId": "user-uid-here",
  "doctorName": "Dr. Sarah Johnson",
  "specialty": "Cardiologist",
  "dateTime": "timestamp",
  "location": "City Medical Center, Room 305",
  "status": "Pending",
  "createdAt": "timestamp"
}
```

#### doctors/{doctorId}
```json
{
  "name": "Dr. Sarah Johnson"
}
```

#### specialties/{specialtyId}
```json
{
  "name": "Cardiologist"
}
```

## Setup Instructions

### 1. Firebase Console Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **rugged-scion-288306**
3. Enable Authentication:
   - Go to Authentication > Sign-in method
   - Enable Email/Password
   - Enable Anonymous
4. Create Firestore Database:
   - Go to Firestore Database
   - Click "Create database"
   - Choose production mode or test mode
   - Select a location

### 2. Firestore Security Rules (Optional but Recommended)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Users can read/write their own appointments
    match /appointments/{appointmentId} {
      allow read, write: if request.auth != null &&
                           request.resource.data.userId == request.auth.uid;
    }

    // Everyone can read doctors and specialties
    match /doctors/{doctorId} {
      allow read: if request.auth != null;
    }

    match /specialties/{specialtyId} {
      allow read: if request.auth != null;
    }
  }
}
```

### 3. Seed Data (Optional)
You can add initial doctors and specialties to Firestore:

**Doctors Collection:**
- Add documents with field `name` containing doctor names

**Specialties Collection:**
- Add documents with field `name` containing specialty names

If these collections are empty, the app will use default hardcoded values.

## What Changed from Placeholder Data

### Files Modified
1. **lib/main.dart** - Added Firebase initialization and auth state management
2. **lib/pages/my_appointments_page.dart** - Now uses Firestore stream for real-time appointments
3. **lib/pages/book_appointment_page.dart** - Saves appointments to Firestore
4. **lib/pages/profile_page.dart** - Loads user profile from Firestore, added logout
5. **lib/models/user_profile.dart** - Added email, phone, address fields
6. **pubspec.yaml** - Added Firebase dependencies

### Files Created
1. **lib/services/firebase_service.dart** - All Firebase operations
2. **lib/pages/auth_page.dart** - Login/signup page
3. **lib/firebase_options.dart** - Firebase configuration
4. **FIREBASE_SETUP.md** - This documentation

### Files Deprecated
1. **lib/data/placeholder_data.dart** - No longer used (but kept for reference)

## Running the App

1. Ensure you have the `firebase-key.json` file in the project root (already present)
2. Run `flutter pub get` to install dependencies
3. Run the app with `flutter run`

## Default Behavior

- If Firestore collections for doctors/specialties are empty, the app uses fallback default values
- New users signing up will have their profile created automatically
- Guest users (anonymous auth) get a default "Guest User" profile
- All appointments are tied to the authenticated user

## Testing

You can test the app by:
1. Creating a new account with email/password
2. Booking appointments
3. Viewing appointments in the My Appointments tab
4. Logging out and logging back in to verify data persistence
5. Using guest mode to test anonymous authentication
