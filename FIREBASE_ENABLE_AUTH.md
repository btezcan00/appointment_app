# How to Enable Firebase Authentication

## Step 1: Enable Authentication Methods

1. Go to https://console.firebase.google.com/
2. Select project: **rugged-scion-288306**
3. Click **Authentication** in the left menu
4. Click **Get Started** (if it's your first time)
5. Click the **Sign-in method** tab
6. Enable the following providers:

### Email/Password
- Click on **Email/Password**
- Toggle **Enable** to ON
- Click **Save**

### Anonymous (for Guest Mode)
- Click on **Anonymous**
- Toggle **Enable** to ON
- Click **Save**

## Step 2: Create Firestore Database

1. Click **Firestore Database** in the left menu
2. Click **Create database**
3. Choose **Start in test mode** (for development)
   - This allows read/write access for 30 days
   - For production, use the security rules from FIREBASE_SETUP.md
4. Select a location (choose closest to you)
5. Click **Enable**

## Step 3: (Optional) Set up Security Rules

Replace the default rules with these for better security:

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
      allow read: if request.auth != null &&
                     resource.data.userId == request.auth.uid;
      allow write: if request.auth != null &&
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

## Step 4: Test the App

1. Run: `flutter run`
2. Sign up with a test email/password
3. Try booking an appointment
4. Check Firebase Console to see the data

## Troubleshooting

**If you get "FirebaseException: Permission denied":**
- Make sure Firestore is in test mode or security rules are set correctly
- Check that Authentication is enabled

**If authentication fails:**
- Check that Email/Password provider is enabled in Firebase Console
- Ensure password is at least 6 characters
- Check console logs for specific error messages
