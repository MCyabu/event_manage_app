プロジェクト レベルの build.gradle（`<project>/build.gradle`）:

```
buildscript {
 repositories {
  // Check that you have the following line (if not, add it):
  google()  // Google's Maven repository
 }
 dependencies {
  ...
  // Add this line
  classpath 'com.google.gms:google-services:4.3.4'
 }
}

allprojects {
 ...
 repositories {
  // Check that you have the following line (if not, add it):
  google()  // Google's Maven repository
  ...
 }
}
```

アプリレベルの build.gradle（`<project>/<app-module>/build.gradle`）:
```
apply plugin: 'com.android.application'
// Add this line
apply plugin: 'com.google.gms.google-services'

dependencies {
 // Import the Firebase BoM
 implementation platform('com.google.firebase:firebase-bom:26.2.0')

 // Add the dependencies for the desired Firebase products
 // https://firebase.google.com/docs/android/setup#available-libraries
}
```

