# 💬 Flutter Chat App (Chatloop)

A Flutter-based real-time group chat application built using Firebase, Riverpod, Hive, Clean Architecture, and GoRouter.
The app supports email/password login, Google authentication, speech-to-text messaging, offline message storage, and multi-language localization (English 🇺🇸 & Bangla 🇧🇩).
---

## Features

- *Firebase Authentication* — Email/Password & Google Sign-In  
- *Real-time Firestore Database*  
- *Offline Chat Storage* with Hive (message create, delete, update methods available)  
- *Riverpod* for state management  
- *Speech-to-Text Integration*  
- *Connectivity Check* (with Toast notifications for offline mode)  
- *Language Switcher* with Flutter Intl + SharedPreferences — English 🇺🇸 / Bangla 🇧🇩  
- *Clean Routing* with GoRouter   
- *Auto Scroll to Latest Message* in chat view
- *Speech Bubble Overlay* — for user guide

---
## Download APK

[Download APK](https://drive.google.com/file/d/1hcENTyGuzfAIx0x2-wqMsVsV_Cfg1UXJ/view?usp=drive_link)

## Wave Gif -> Speech Recognization icon
[Download Gif](https://drive.google.com/file/d/1DqMzSvgo057AIbEfL0GzViFpydEXYczL/view?usp=sharing)

## Setup Instructions

1. Clone the repository:
   - git clone https://github.com/kazihabiba201/chat_app
   - cd chat_app

2. Install dependencies:
   - flutter pub get

3. Setup Firebase:
   - Add your google-services.json (Android) or GoogleService-Info.plist (iOS) file.
   - Configure firebase_options.dart using FlutterFire CLI.

4. Run the app:
   - flutter run
  
##  Dependencies

| Package | Version | Description |
|----------|----------|-------------|
| *cupertino_icons* | ^1.0.2 | iOS-style icons for Flutter |
| *cloud_firestore* | ^5.4.0 | Cloud Firestore database integration |
| *firebase_auth* | ^5.2.0 | Firebase authentication support |
| *firebase_core* | ^3.4.0 | Core Firebase initialization package |
| *go_router* | ^14.6.2 | Declarative navigation and routing for Flutter |
| *flutter_riverpod* | ^2.6.1 | State management library |
| *google_sign_in* | ^6.2.2 | Google authentication integration |
| *hive* | ^2.2.3 | Lightweight, fast local NoSQL database |
| *hive_generator* | ^2.0.1 | Code generator for Hive TypeAdapters |
| *hive_flutter* | ^1.1.0 | Hive integration for Flutter apps |
| *speech_to_text* | ^6.6.2 | Converts speech input to text |
| *connectivity_plus* | ^6.1.5 | Network connectivity status and monitoring |
| *fluttertoast* | ^8.2.8 | Display toast messages on Android/iOS |
| *intl* | any | Internationalization and localization utilities |
| *shared_preferences* | ^2.2.3 | Persistent key-value storage |

---

##  Dev Dependencies

| Package | Version | Description |
|----------|----------|-------------|
| *flutter_test* | SDK | Flutter's testing framework |
| *flutter_localizations* | SDK | Localization support for Flutter |
| *flutter_launcher_icons* | ^0.14.4 | Generate app launcher icons automatically |

---

##  App Icon Configuration

yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/images/app_logo.png"

## Screenshots

| Logo |  |  |
| ------------ | ----------- | ----------------- |
| ![Logo](https://github.com/user-attachments/assets/055eb9a4-fc72-4e80-81a3-100769e1b14a) |
| Splash Screen | SignUp Screen | Login Screen |
| ![Splash](https://github.com/user-attachments/assets/f74e2a6f-d5d8-488c-90da-c40b56d01562) | ![Signup](https://github.com/user-attachments/assets/ca676884-071b-4754-a0a8-e222d58ffc8c) | ![Login](https://github.com/user-attachments/assets/8db35cf0-297b-4030-9152-055f66fc27de) |
| Chat Screen | Message Delete | Message Edit |
| ![Chat](https://github.com/user-attachments/assets/36a0be58-3476-48ef-bb42-6fe2cfde3058) | ![delete](https://github.com/user-attachments/assets/d0aa6b34-ea9c-4ff1-9e3c-5e2df0dab2c8) | ![Edit](https://github.com/user-attachments/assets/e574469c-b238-413f-8f45-24ae1f63c93a) |
