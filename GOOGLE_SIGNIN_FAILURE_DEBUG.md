# Google Sign-In Failure - Complete Debugging Guide

## ✅ Fixed Issues:

1. ✅ Added **INTERNET** permission to AndroidManifest.xml
2. ✅ Added **ACCESS_NETWORK_STATE** permission
3. ✅ Set **minSdk = 21** (Firebase requirement)

---

## 📋 Common Reasons Google Sign-In Fails:

### **❌ 1. Missing INTERNET Permission**
**Symptom:** Google Sign-In button does nothing or times out

**Fix:**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    ...
</manifest>
```

**Status:** ✅ Already fixed

---

### **❌ 2. minSdkVersion Too Low**
**Symptom:** Firebase/Google Sign-In crashes on install

**Why:** Google Play Services & Firebase require SDK 21+

**Fix:**
```kotlin
// android/app/build.gradle.kts
defaultConfig {
    minSdk = 21  // ✅ MUST BE AT LEAST 21
    targetSdk = flutter.targetSdkVersion
}
```

**Status:** ✅ Already fixed

---

### **❌ 3. SHA-1 Fingerprint Not Registered**
**Symptom:** `com.google.android.gms.tasks.RuntimeExecutionException`

**Cause:** Firebase Console doesn't recognize your app

**Fix:**
```bash
# 1. Get your debug SHA-1
cd android
./gradlew signingReport

# 2. You'll see output like:
# SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD

# 3. Add to Firebase Console:
#    - Go to: https://console.firebase.google.com/
#    - Project: library-app-daf1d
#    - Project Settings → Android app
#    - Add SHA-1 fingerprint
#    - Download new google-services.json
#    - Replace android/app/google-services.json
```

**Status:** ⚠️ Check if SHA-1 is registered

---

### **❌ 4. Google Sign-In Not Enabled in Firebase**
**Symptom:** No Google account picker appears

**Cause:** Google Sign-In not enabled in Firebase Console

**Fix:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Project: `library-app-daf1d`
3. **Authentication** → **Sign-in method** tab
4. Find **Google** provider
5. Check if it's **Enabled** (blue toggle)
6. If disabled → Click it → Enable → Select support email → Save
7. Download new `google-services.json`
8. Replace `android/app/google-services.json`

**Status:** ⚠️ Verify Google is enabled

---

### **❌ 5. No Internet Connection on Device**
**Symptom:** Google Sign-In hangs forever

**Fix:**
- Check device has WiFi/Mobile data
- Try: `adb shell ping 8.8.8.8`
- Enable Developer Mode
- Check internet on browser

**Status:** ⚠️ User error, not code

---

### **❌ 6. Google Play Services Not Installed**
**Symptom:** On emulator: "Google Play Services not installed"

**Fix:**
- Use emulator with Google Play: `ARM64 API 30 (with Play)`
- Or use: Google Pixel 4 API 30
- Install manually: `adb install GooglePlayServices.apk`

**Status:** ⚠️ Emulator setup issue

---

### **❌ 7. Wrong Package Name**
**Symptom:** `The specified Android package does not exist`

**Your package name:** `com.example.flutter_application_4`

**Verify:**
```kotlin
// android/app/build.gradle.kts
defaultConfig {
    applicationId = "com.example.flutter_application_4"  // ✅ Correct
}
```

**Firebase must match:**
1. Firebase Console → Project Settings → Android app
2. Should show: `com.example.flutter_application_4`
3. If not, re-register the app with correct name

**Status:** ⚠️ Check Firebase Console

---

### **❌ 8. Cleared App Cache Issues**
**Symptom:** Worked once, then stopped working

**Fix:**
```bash
# Clear app cache
adb shell pm clear com.example.flutter_application_4

# Uninstall completely
adb uninstall com.example.flutter_application_4

# Reinstall
flutter run
```

**Status:** ⚠️ Try if nothing else works

---

### **❌ 9. Development & Release Builds Use Different Keys**
**Symptom:** Works in debug, fails in release

**Reason:** Debug and Release use different SHA-1 fingerprints

**Fix:**
- For debug builds (development): Use debug SHA-1 ✅
- For release builds: Get release keystore SHA-1
  ```bash
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```

**Status:** ⚠️ Only if building release

---

## 🔍 How to Debug:

### **Step 1: Check Logs**
```bash
flutter logs | grep -i "google\|sign"
```

### **Step 2: Look for These Messages**
```
✅ Google Sign-In successful
❌ Google Sign-In cancelled by user
❌ Google Sign-In Error: 
❌ Google Sign-In Exception:
```

### **Step 3: Add Debug Print to Code**
```dart
void debugGoogleSignIn() async {
  print('1. Starting Google Sign-In...');
  
  try {
    print('2. Attempting signIn()...');
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    print('3. Got user: ${googleUser?.email}');
    
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('4. Got auth tokens');
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('5. Created credential');
      
      await _auth.signInWithCredential(credential);
      print('6. Firebase sign-in complete ✅');
    }
  } catch (e) {
    print('ERROR: $e');
  }
}
```

---

## 🚀 Complete Checklist:

- [ ] INTERNET permission added to AndroidManifest.xml
- [ ] ACCESS_NETWORK_STATE permission added
- [ ] minSdk = 21 in build.gradle.kts
- [ ] google_sign_in package installed: `flutter pub add google_sign_in`
- [ ] Firebase Authentication has Google enabled
- [ ] SHA-1 fingerprint registered in Firebase
- [ ] google-services.json downloaded and in android/app/
- [ ] AuthService has clientId configured
- [ ] Login screen has Google Sign-In button
- [ ] Register screen has Google Sign-Up button
- [ ] Device/Emulator has internet connection
- [ ] Google Play Services installed on emulator
- [ ] Package name matches Firebase app registration

---

## 🔧 Quick Fix Command:

If still broken, run this:
```bash
flutter clean
flutter pub get
flutter pub add google_sign_in
flutter run
```

---

## 📱 Test Steps:

1. **Open app**
2. **Click "Sign in with Google"** or **"Sign up with Google"**
3. **Google account picker appears** ← Should see list of accounts
4. **Select your Google account**
5. **Redirected to dashboard** ← Success! ✅

If any step fails, check the logs:
```bash
flutter logs
```

---

## 📞 If Still Broken:

### Check these in order:

1. **Run:**
   ```bash
   flutter logs | grep -i "google"
   ```
   Look for error message

2. **Verify SHA-1:**
   ```bash
   cd android && ./gradlew signingReport
   ```
   Compare with Firebase Console

3. **Check Firebase:**
   - Go to: https://console.firebase.google.com/
   - Project: library-app-daf1d
   - Authentication → Sign-in method → Google (should be blue/enabled)

4. **Check Permissions:**
   - Device Settings → Apps → flutter_application_4 → Permissions
   - Should have: Internet ✅

5. **Reinstall:**
   ```bash
   adb uninstall com.example.flutter_application_4
   flutter clean
   flutter run
   ```

---

## ✅ Success Message:

When working correctly, you should see in logs:
```
Google Sign-In successful
```

And app should redirect to Dashboard automatically.

