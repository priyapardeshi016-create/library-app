# Complete Firebase Setup Guide for Flutter

## Step 1: Install Firebase CLI

### For Windows (PowerShell):
```powershell
npm install -g firebase-tools
```

### Verify Installation:
```powershell
firebase --version
```

---

## Step 2: Install FlutterFire CLI

### Why? 
FlutterFire CLI automates Firebase setup for Flutter projects.

```bash
dart pub global activate flutterfire_cli
```

### Fix "flutterfire not recognized" Error:

If you get this error, add Flutter to PATH:

**Windows Users:**
1. Go to: `C:\Users\<YourUsername>\AppData\Local\Pub\Cache\bin`
2. Copy the full path
3. Add to Windows Environment Variables (PATH)
4. Restart PowerShell
5. Test: `flutterfire --version`

---

## Step 3: Firebase Project Setup

### 3.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create Project"
3. Enter project name: `library-app`
4. Accept terms and create

### 3.2 Register Android App
1. In Firebase Console → Project Settings
2. Click "Add App" → Choose Android
3. Enter package name: `com.example.flutter_application_4`
4. Download `google-services.json`
5. Place it in: `android/app/`

### 3.3 Register Web App (Optional)
1. Click "Add App" → Choose Web
2. Register the app
3. Copy Firebase config

---

## Step 4: Run FlutterFire Configure

### What it does:
- Generates `firebase_options.dart`
- Configures Android/iOS/Web
- Sets up all necessary plugins

### Command:
```bash
flutterfire configure
```

### What happens:
- Asks which platforms (Android/iOS/Web)
- Generates `lib/firebase_options.dart` automatically
- Updates Android files automatically

### If it fails:
```bash
flutter pub get
flutter clean
flutterfire configure --reconfigure
```

---

## Step 5: Add Firebase Dependencies to pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.30.0
  firebase_auth: ^4.19.0
  cloud_firestore: ^4.13.6
  google_sign_in: ^6.1.6
  
  # Other packages
  provider: ^6.0.5
  google_fonts: ^6.1.0
```

### Install:
```bash
flutter pub get
```

---

## Step 6: Android Configuration (CRITICAL)

### 6.1 Update `android/app/build.gradle.kts`

Add Google Services plugin at the TOP of the file:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ✅ ADD THIS
}

android {
    namespace = "com.example.flutter_application_4"
    compileSdk = flutter.compileSdkVersion
    
    defaultConfig {
        applicationId = "com.example.flutter_application_4"
        minSdk = 21  // ✅ MUST BE AT LEAST 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}

flutter {
    source = "../.."
}
```

### 6.2 Update `android/build.gradle.kts`

Add Google Services plugin declaration:

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

### 6.3 Verify `android/app/google-services.json` exists

Check: `android/app/google-services.json` should exist with content like:

```json
{
  "project_info": {
    "project_number": "443170641219",
    "project_id": "library-app-daf1d",
    "storage_bucket": "library-app-daf1d.firebasestorage.app"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:443170641219:android:26add17b2054596b1c0bf6",
        "android_client_info": {
          "package_name": "com.example.flutter_application_4"
        }
      },
      "api_key": [
        {
          "current_key": "AIzaSyDFzukLAtl4QGJ9MTU5G4ri7wY4fg-2roM"
        }
      ]
    }
  ],
  "configuration_version": "1"
}
```

---

## Step 7: Generate firebase_options.dart

### If using flutterfire configure:
It generates automatically → `lib/firebase_options.dart`

### Manual Alternative:
Create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFzukLAtl4QGJ9MTU5G4ri7wY4fg-2roM',
    appId: '1:443170641219:android:26add17b2054596b1c0bf6',
    messagingSenderId: '443170641219',
    projectId: 'library-app-daf1d',
    storageBucket: 'library-app-daf1d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:443170641219:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '443170641219',
    projectId: 'library-app-daf1d',
    storageBucket: 'library-app-daf1d.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:443170641219:web:YOUR_WEB_APP_ID',
    messagingSenderId: '443170641219',
    projectId: 'library-app-daf1d',
    storageBucket: 'library-app-daf1d.firebasestorage.app',
  );
}
```

---

## Step 8: Initialize Firebase in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // ✅ Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      home: const HomeScreen(),
    );
  }
}
```

### Explanation:
- `WidgetsFlutterBinding.ensureInitialized()` - Ensures Flutter is initialized before Firebase
- `Firebase.initializeApp()` - Connects your app to Firebase project
- `DefaultFirebaseOptions.currentPlatform` - Uses correct platform credentials

---

## Step 9: Test Firebase Connection

### Create a test screen:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Firebase Status: ✅ Connected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => testSignUp(),
              child: const Text('Test Firebase Auth'),
            ),
          ],
        ),
      ),
    );
  }

  void testSignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );
      print('✅ Firebase Auth Works!');
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}
```

---

## Step 10: Clean Build & Run

```bash
flutter clean
flutter pub get
flutter pub get
flutter run
```

---

## Common Errors & Fixes

### ❌ Error: "flutterfire: The term 'flutterfire' is not recognized"
**Fix:**
```powershell
# Add to PATH
$env:PATH += ";C:\Users\<YourUsername>\AppData\Local\Pub\Cache\bin"

# Or permanently add it via Environment Variables
```

---

### ❌ Error: "MissingPluginException: No implementation found"
**Fix:**
```bash
flutter clean
flutter pub get
flutter run
```

---

### ❌ Error: "Gradle sync failed"
**Fix:**
1. Check `android/app/build.gradle.kts` has Google Services plugin
2. Check `minSdkVersion` is at least 21
3. Run: `flutter clean && flutter pub get`

---

### ❌ Error: "Unable to find google-services.json"
**Fix:**
1. Download from Firebase Console
2. Place in: `android/app/google-services.json`
3. Not in `android/`!

---

### ❌ Error: "FirebaseCore was not initialized"
**Fix:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // ✅ ADD THIS
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## Quick Checklist

- [ ] Firebase CLI installed: `firebase --version`
- [ ] FlutterFire CLI installed: `flutterfire --version`
- [ ] Firebase project created
- [ ] Android app registered
- [ ] `google-services.json` in `android/app/`
- [ ] `firebase_options.dart` generated
- [ ] `firebase_core` dependency added
- [ ] `android/app/build.gradle.kts` has Google Services plugin
- [ ] `android/build.gradle.kts` has Google Services plugin
- [ ] `minSdkVersion` is at least 21
- [ ] `main.dart` initializes Firebase
- [ ] `flutter run` works without errors

---

## Next Steps

Once Firebase is connected:

### 1. **Set up Authentication:**
```dart
// Register
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Login
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Google Sign-In
final credential = await signInWithGoogle();
await FirebaseAuth.instance.signInWithCredential(credential);
```

### 2. **Set up Firestore:**
```dart
// Add document
await FirebaseFirestore.instance
  .collection('books')
  .add({
    'title': 'Flutter Guide',
    'author': 'John Doe',
  });

// Read documents
FirebaseFirestore.instance
  .collection('books')
  .snapshots()
  .listen((snapshot) {
    for (var doc in snapshot.docs) {
      print(doc.data());
    }
  });
```

### 3. **Set up Cloud Storage:**
```dart
// Upload file
await FirebaseStorage.instance
  .ref('books/cover.jpg')
  .putFile(file);

// Download URL
String url = await FirebaseStorage.instance
  .ref('books/cover.jpg')
  .getDownloadURL();
```

---

## Important Notes

⚠️ **Security Rules:** Set proper Firestore rules in Firebase Console
⚠️ **API Keys:** Never commit `google-services.json` to public repo
⚠️ **minSdkVersion:** Firebase requires SDK 21 minimum
⚠️ **Internet:** Ensure device has internet connection
⚠️ **Credentials:** Keep API keys confidential

---

## Additional Resources

- [Firebase Documentation](https://firebase.flutter.dev/)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)
- [Flutter Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Firestore Rules](https://firebase.google.com/docs/firestore/security)

