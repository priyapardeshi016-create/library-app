# Google Sign-In ClientID Fix

## ✅ Issue Fixed!

### What Was Wrong:
```
Google Sign-In Exception: Assertion failed
"ClientID not set. Either set it on a <meta name="google-signin-client_id"..."
```

The Google Sign-In library couldn't find the Web Client ID.

---

## ✅ What I Fixed:

### 1. Updated `auth_service.dart`
Added the Web Client ID to GoogleSignIn initialization:

```dart
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  
  // 🔑 Web Client ID from google-services.json
  static const String _webClientId =
      '443170641219-ab0v0kccvuc2u2fgns8grv5brkupde64.apps.googleusercontent.com';
  
  static final _googleSignIn = GoogleSignIn(
    clientId: _webClientId,  // ✅ NOW CONFIGURED
  );
}
```

### 2. Verified `google-services.json`
Confirmed it has the oauth_client configuration:

```json
"oauth_client": [
  {
    "client_id": "443170641219-ab0v0kccvuc2u2fgns8grv5brkupde64.apps.googleusercontent.com",
    "client_type": 3
  }
]
```

---

## 🚀 Run Now:

```bash
flutter clean
flutter pub get
flutter run
```

---

## ✅ Test Google Sign-In:

1. Open app
2. Click "Sign in with Google" OR "Sign up with Google"
3. Google account picker should appear
4. Select your Google account
5. Should successfully sign in ✅

---

## 📝 What This Does:

- `clientId`: Tells Google which app is requesting authentication
- Web Client ID: Works across Android, iOS, and Web
- `GoogleSignIn(clientId: ...)`: Initializes with proper credentials

---

## ❌ If Still Not Working:

### Check 1: Verify Client ID
```dart
print('Web Client ID: 443170641219-ab0v0kccvuc2u2fgns8grv5brkupde64.apps.googleusercontent.com');
```

### Check 2: Verify google-services.json exists
```bash
ls -la android/app/google-services.json
```

### Check 3: Check Firebase Console
- Go to: https://console.firebase.google.com/
- Project: `library-app-daf1d`
- Check that Google is enabled in Authentication

### Check 4: Run Logs
```bash
flutter logs
```

Look for: `Google Sign-In Exception`

---

## 🔍 How to Find Your Client ID Manually:

If you ever need to find it again:

1. Download `google-services.json` from Firebase Console
2. Open the file and search for: `"oauth_client"`
3. You'll see:
```json
"oauth_client": [
  {
    "client_id": "YOUR_CLIENT_ID_HERE",
    "client_type": 3
  }
]
```

3. Copy that `client_id` value
4. Add to `GoogleSignIn(clientId: "YOUR_CLIENT_ID_HERE")`

---

## ✨ Summary

Your Google Sign-In is now properly configured with:
- ✅ Web Client ID
- ✅ Firebase Authentication
- ✅ Proper OAuth configuration
- ✅ Both Login & Register screens

Should work now! 🎉

