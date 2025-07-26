Hobify - Flutter Spotify Clone
==============================

A feature-rich music streaming application built with Flutter that replicates Spotify's core functionality, including background audio playback, user authentication, and music discovery.

📱 Features
-----------

*   **🎵 Music Streaming**: Stream music from Spotify's catalog via YouTube audio.
    
*   **🔄 Background Playback**: Continue listening when the app is minimized or the screen is locked.
    
*   **🔐 User Authentication**: Firebase-based login and registration system.
    
*   **❤️ Liked Songs**: Save and manage your favorite tracks.
    
*   **📱 Lock Screen Controls**: Control playback from the notification panel and lock screen.
    
*   **🔀 Shuffle & Repeat**: Full playback control with shuffle and repeat modes.
    
*   **📜 Playlists**: Create and manage custom playlists.
    
*   **🔍 Search**: Discover new music and artists.
    
*   **👤 User Profile**: Manage account settings and preferences.
    
*   **📊 Recently Played**: Track your listening history.
    

🛠️ Tech Stack
--------------

*   **Frontend**: Flutter (Dart)
    
*   **Backend**: Firebase (Authentication, Firestore)
    
*   **Audio**: just\_audio, just\_audio\_background
    
*   **APIs**: Spotify Web API, YouTube Explode
    
*   **State Management**: setState (can be upgraded to Provider/Bloc)
    

📋 Prerequisites
----------------

*   Flutter SDK (latest stable version)
    
*   Android Studio / VS Code with Flutter extensions
    
*   A Firebase project setup
    
*   A Spotify Developer Account (for API credentials)
    
*   An Android device or emulator (API level 21+)
    

🚀 Installation
---------------

> **Important Note**This application is configured for production using the developer's private API keys. You will be unable to install and run the app on your device until you replace them with your own Firebase and Spotify credentials as outlined in the steps below.

### 1\. Clone the Repository

  git clone https://github.com/Pawan-bari/hobify.git   `

### 2\. Install Dependencies

`   cd hobify  flutter pub get   `

### 3\. Firebase Setup

1.  Create a new Firebase project at the [Firebase Console](https://console.firebase.google.com/).
    
2.  Enable **Authentication** (Email/Password method).
    
3.  Create a **Firestore** database in test mode.
    
4.  Download the google-services.json file and place it in the android/app/ directory.
    
5.  Update lib/firebase\_options.dart with your Firebase configuration by running the FlutterFire CLI: flutterfire configure.
    

### 4\. Spotify API Setup

1.  Create a new app at the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard).
    
2.  Get your **Client ID** and **Client Secret**.
    
3.  class Controller { static const String clienid = 'YOUR\_SPOTIFY\_CLIENT\_ID';
4.  static const String clienttoken = 'YOUR\_SPOTIFY\_CLIENT\_SECRET';}
    

### 5\. Run the Application

`   flutter run   `




📄 License
----------

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

`   MIT License  Copyright (c) 2024 Pawan Bari  Permission is hereby granted, free of charge, to any person obtaining a copy  of this software and associated documentation files (the "Software"), to deal  in the Software without restriction, including without limitation the rights  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  copies of the Software, and to permit persons to whom the Software is  furnished to do so, subject to the following conditions:  The above copyright notice and this permission notice shall be included in all  copies or substantial portions of the Software.  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  SOFTWARE.   `

⚠️ Disclaimer
-------------

This is an **educational project** created for learning purposes. It uses:

*   **Spotify Web API** for music metadata (requires valid API credentials).
    
*   **YouTube** for audio streaming (subject to their terms of service).
    

This application is **not affiliated with Spotify AB** or Google/YouTube. Users are responsible for complying with both services' terms of use. The app does not store or redistribute copyrighted content.

**Made with ❤️ using Flutter | Educational Project | Not affiliated with Spotify**
