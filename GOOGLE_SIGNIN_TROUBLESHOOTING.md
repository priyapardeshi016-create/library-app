# Google Sign-In Troubleshooting Guide

## ✅ Google Sign-In Now Available In Both Screens:

1. **Login Screen** - "Sign in with Google" button
2. **Register Screen** - "Sign up with Google" button

---

## 🔧 Step 1: Verify Google Sign-In is Configured

### Check Firebase Console:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `library-app-daf1d`
3. Go to: **Authentication** → **Sign-in method**
4. Look for **Google** - Should be **Enabled** (blue toggle)

If NOT enabled:
- Click on Google
- Click **Enable**
- Select a Support email
- Click **Save**

---

## 🔧 Step 2: Get SHA-1 Fingerprint for Android

Your app needs SHA-1 fingerprint registered in Firebase.

### Get Debug SHA-1:
```bash
cd android
./gradlew signingReport
```

Look for output like:
```
Task :app:signingReport
...
debug:
    Variant: debug
    Config: debug
    Store: C:\Users\priya pardeshi\.android\debug.keystore
    Alias: AndroidDebugKey
    MD5: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
    SHA-256: ...
```

**Copy the SHA1 value** (looks like: `AA:BB:CC:DD:...`)

### Add to Firebase:
1. Firebase Console → Project Settings
2. Click "Android" app
3. Scroll down to **SHA certificate fingerprints**
4. Click **Add Fingerprint**
5. Paste the SHA1 value
6. Click **Save**
7. Download updated `google-services.json`
8. Replace your `android/app/google-services.json`

---

## 🔧 Step 3: Verify Android Configuration

### Check `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ✅ MUST BE HERE
}

android {
    namespace = "com.example.flutter_application_4"
    compileSdk = flutter.compileSdkVersion
    
    defaultConfig {
        applicationId = "com.example.flutter_application_4"
        minSdk = 21  // ✅ MUST BE 21 OR HIGHER
        targetSdk = flutter.targetSdkVersion
        ...
    }
}
```

### Check `android/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

---

## 🔧 Step 4: Verify AuthService

Check `lib/services/auth_service.dart` has:

```dart
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _googleSignIn = GoogleSignIn();

  // 🔐 Google Sign-In
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      print('Google Sign-In successful');
      return true;
    } catch (e) {
      print('Google Sign-In Exception: $e');
      return false;
    }
  }
}
```

---

## 🔧 Step 5: Clean and Run

```bash
flutter clean
flutter pub get
flutter pub get
flutter run
```

---

## ❌ Common Errors & Solutions

### ❌ Error: "The identity provider configuration is not found"
**Cause:** Google Sign-In not enabled in Firebase

**Fix:**
1. Firebase Console → Authentication → Sign-in method
2. Enable Google
3. Download new `google-services.json`
4. Replace `android/app/google-services.json`
5. Run: `flutter clean && flutter run`

---

### ❌ Error: "com.google.android.gms.tasks.RuntimeExecutionException"
**Cause:** SHA-1 fingerprint not registered

**Fix:**
1. Get SHA-1: `cd android && ./gradlew signingReport`
2. Add to Firebase Console → Project Settings → Android app
3. Download new `google-services.json`
4. Replace `android/app/google-services.json`
5. Run: `flutter clean && flutter run`

---

### ❌ Error: "User cancelled the sign-in flow"
**Cause:** User pressed back/cancel during Google sign-in

**Fix:**
- This is normal behavior. App catches it and shows "Google Sign-Up Failed"
- User can try again

---

### ❌ Error: "PlatformException(sign_in_failed, ...)"
**Cause:** Usually SHA-1 fingerprint mismatch or Google project not properly configured

**Fix:**
1. Verify SHA-1 in Firebase Console matches your debug keystore
2. Make sure you're using debug APK (not release)
3. Check internet connection
4. Clear app data: `adb shell pm clear com.example.flutter_application_4`
5. Uninstall and reinstall: `flutter run`

---

### ❌ Error: "The specified Android package does not exist"
**Cause:** Package name mismatch

**Fix:**
1. Your package name: `com.example.flutter_application_4`
2. Firebase Console → Project Settings → Android app
3. Verify package name matches exactly (case-sensitive)
4. If not, re-register the app with correct package name

---

### ❌ Error: "Cannot find google_sign_in plugin"
**Cause:** Plugin not installed

**Fix:**
```bash
flutter pub get
flutter pub add google_sign_in
flutter clean
flutter run
```

---

## ✅ Testing Google Sign-In

### Test on Android Emulator:
1. Start emulator
2. Make sure Google Play Services are installed
3. Run app: `flutter run`
4. Click "Sign in with Google" or "Sign up with Google"
5. Select or add Google account
6. Should redirect to dashboard if successful

### Test on Physical Device:
1. Connect device via USB
2. Enable Developer Mode on device
3. Run app: `flutter run`
4. Click Google Sign-In button
5. Google account picker appears
6. Select account
7. Should redirect to dashboard

---

## 🔍 Debug Google Sign-In

Add this to see detailed logs:

```dart
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

void debugGoogleSignIn() async {
  print('Available accounts:');
  List<GoogleSignInAccount> accounts = await _googleSignIn.disconnect();
  print('Accounts: $accounts');
  
  print('Attempting sign in...');
  GoogleSignInAccount? account = await _googleSignIn.signIn();
  print('Signed in as: ${account?.email}');
}
```

---

## 📋 Google Sign-In Checklist

- [ ] Google enabled in Firebase Authentication
- [ ] SHA-1 fingerprint registered in Firebase
- [ ] `google-services.json` downloaded and in `android/app/`
- [ ] `google_sign_in` package installed: `flutter pub add google_sign_in`
- [ ] `AuthService` has `signInWithGoogle()` method
- [ ] Login screen has Google Sign-In button
- [ ] Register screen has Google Sign-Up button ✅ (just added)
- [ ] `android/app/build.gradle.kts` has Google Services plugin
- [ ] `android/build.gradle.kts` has Google Services plugin
- [ ] `minSdkVersion` is at least 21
- [ ] `flutter clean && flutter run` executed

---

## 📱 How It Works

### User clicks "Sign in with Google":
1. Google account picker appears
2. User selects account
3. Google returns ID token & Access token
4. Your app exchanges tokens for Firebase credential
5. Firebase signs user in
6. User automatically logged into your app ✅

### User clicks "Sign up with Google":
1. Same as above, but creates new user if first time
2. User data saved to Firebase Authentication
3. Can now use email/password login too

---

## 🔐 Security Notes

⚠️ **Never:**
- Share SHA-1 fingerprints publicly
- Commit `google-services.json` to public GitHub (add to `.gitignore`)
- Use release keystore SHA-1 for debug testing

---

## 📞 Still Not Working?

1. **Check Firestore Rules** - Make sure rules allow authentication:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

2. **Check Internet Connection** - Device must have internet

3. **Check Google Account** - Account must have Android as recovery method

4. **Check Logcat** - Run: `flutter logs` to see real-time errors

5. **Reinstall App** - Sometimes cached credentials cause issues:
```bash
flutter clean
flutter pub get
flutter run
```

---

## ✨ Next Steps

Once Google Sign-In works:
1. Test registration with Google
2. Test login with Google  
3. Test switching between Email and Google auth
4. Test logout (should clear Google session too)
5. Test adding books after signing in with Google

