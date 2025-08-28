
# 🎵 Spotify Clone - Flutter Music Streaming App

A feature-rich music streaming application built with Flutter that replicates core Spotify functionality. The app integrates with Spotify Web API for music data and YouTube for audio streaming, providing users with a seamless music listening experience.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### 🎶 Core Music Features
- **Music Streaming**: Stream music from YouTube with Spotify metadata
- **Search Functionality**: Search for songs, artists, and albums
- **Audio Controls**: Play, pause, skip, previous, shuffle, and repeat modes
- **Progress Tracking**: Real-time progress bar with seek functionality
- **Queue Management**: Playlist-based playback with next/previous navigation

### 📱 User Experience
- **User Authentication**: Email/password registration and login
- **Profile Management**: Customizable user profiles with image upload
- **Recently Played**: Track and display recently played songs
- **Liked Songs**: Heart songs to save them to your liked collection
- **Playlist Management**: Create, edit, and delete custom playlists

### 🎨 Modern UI/UX
- **Dark Theme**: Spotify-inspired dark theme design
- **Responsive Design**: Optimized for different screen sizes
- **Smooth Animations**: Fluid transitions and loading states
- **Bottom Navigation**: Easy navigation between Home, Search, Library, and Profile

### 🔧 Advanced Features
- **Real-time Updates**: Live sync of likes, playlists, and recently played
- **Offline State Management**: Robust error handling and loading states
- **Share Functionality**: Share songs with friends
- **Auto-cleanup**: Automatic cleanup of old recently played tracks

## 📱 Screenshots

<div align="center">

### Home Screen
<img src="https://github.com/user-attachments/assets/954a81ae-f381-4da7-992e-b2a9258b84ee" alt="Home Screen" width="300"/>

*Personalized home screen with recently played tracks, playlists, and quick access shortcuts*

### Music Player
<img src="https://github.com/user-attachments/assets/5478888f-52e5-4943-b79a-373cddf75f1a" alt="Music Player" width="300"/>

*Full-screen music player with album artwork, playback controls, and progress tracking*

### Library
<img src="https://github.com/user-attachments/assets/3b84ef95-df13-4dff-97de-38ef8987b9e8" alt="Library Screen" width="300"/>

*Organized library with playlists, liked songs, and recently played sections*

### Profile
<img src="https://github.com/user-attachments/assets/1a1a5986-bc8c-4bc2-965b-7bb86ce44fb7" alt="Profile Screen" width="300"/>

*User profile management with settings and account options*

</div>

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / VS Code
- Firebase project
- Spotify Developer Account

### 🔑 API Keys Required
1. **Spotify Web API**: Get your client ID and client secret from [Spotify Developer Dashboard](https://developer.spotify.com/)
2. **Firebase**: Set up a Firebase project with Authentication, Firestore, and Storage

### 📦 Installation

1. **Clone the repository**
```

git clone https://github.com/yourusername/spotify_clone.git
cd spotify_clone

```

2. **Install dependencies**
```

flutter pub get

```

3. **Configure Spotify API**

Update `lib/controller/apicontroller/controller.dart`:
```

class Controller {
static const String clienid = 'YOUR_SPOTIFY_CLIENT_ID';
static const String clienttoken = 'YOUR_SPOTIFY_CLIENT_SECRET';
}

```

4. **Configure Firebase**

- Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Update `lib/firebase_options.dart` with your Firebase configuration

5. **Run the application**
```

flutter run

```

## 🏗️ Project Structure

```

lib/
├── Audio page/           \# Music player screens
│   └── player.dart      \# Main audio player
├── controller/          \# Business logic controllers
│   ├── Authentication/  \# Auth services and state management
│   ├── apicontroller/   \# Spotify API controller
│   └── databa/         \# Database services
├── homepage/           \# Main app screens
│   ├── Library/        \# Library and playlist management
│   ├── Search/         \# Search functionality
│   ├── home.dart      \# Home screen
│   ├── homepage.dart   \# Main navigation
│   └── profile/       \# User profile management
├── login\&registerpages/ \# Authentication screens
├── modal/             \# Data models
├── pages/             \# Additional screens
├── services/          \# Service classes
│   ├── likedservices.dart     \# Liked songs management
│   ├── playlistservices.dart  \# Playlist operations
│   └── recentlyplayed.dart    \# Recently played tracking
├── starting_pages/    \# Onboarding screens
├── widget/           \# Reusable widgets
└── main.dart         \# App entry point

```

## 🔥 Firebase Setup

### Firestore Collections Structure

```

users/{uid}/
├── liked/{trackId}           // User's liked songs
│   └── { createdAt: timestamp }
└── recently_played/{trackId} // Recently played tracks
└── { trackId: string, playedAt: timestamp }

playlists/{playlistId}        // User playlists
└── {
id: string,
name: string,
createdBy: string,
createdAt: timestamp,
trackIds: string[],
imageUrl?: string
}

userprofile/{uid}            // User profiles
└── {
name: string,
email: string,
profile_image_url: string
}

```

### Firebase Storage Structure

```

profile_pictures/{uid}.jpg   // User profile images

```

## 📚 Dependencies

### Core Dependencies
```

dependencies:
flutter: sdk: flutter
cupertino_icons: ^1.0.8

# Firebase

firebase_core: ^3.15.1
firebase_auth: ^5.6.2
cloud_firestore: ^5.6.11
firebase_storage: ^12.4.9

# Audio \& Media

just_audio: ^0.10.4
audio_video_progress_bar: ^2.0.3
spotify: ^0.13.7
youtube_explode_dart: ^2.5.2

# UI Components

google_nav_bar: ^5.0.7
hugeicons: ^0.0.11

# Utilities

image_picker: ^1.1.2
share_plus: ^7.2.2

```

## 🎯 Key Features Implementation

### 🎵 Music Playback
- **Audio Streaming**: Uses `just_audio` for high-quality audio playback
- **YouTube Integration**: `youtube_explode_dart` for fetching audio streams
- **Progress Control**: Real-time position tracking and seeking

### 🔐 Authentication
- **Email/Password Auth**: Firebase Authentication integration
- **User State Management**: ValueNotifier for reactive auth state
- **Profile Management**: Firestore integration for user data

### 📊 Data Management
- **Real-time Sync**: Firestore streams for live data updates
- **Local State**: Efficient state management with StreamBuilder
- **Error Handling**: Comprehensive error handling and user feedback

### 🎨 UI/UX Design
- **Material Design**: Following Material Design 3 principles
- **Dark Theme**: Spotify-inspired color scheme
- **Responsive Layout**: Adaptive UI for different screen sizes

## 🚀 Performance Optimizations

- **Lazy Loading**: Efficient loading of track metadata
- **Stream Management**: Proper disposal of audio and data streams
- **Image Caching**: Network image caching for album artwork
- **Memory Management**: Cleanup of old recently played tracks

## 🔧 Configuration

### Environment Setup
1. Enable required APIs in Firebase Console:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage

2. Update Firestore Security Rules:
```

rules_version = '2';
service cloud.firestore {
match /databases/{database}/documents {
// Users can only access their own data
match /users/{userId}/{document=**} {
allow read, write: if request.auth != null \&\& request.auth.uid == userId;
}

    // Playlists created by the user
    match /playlists/{playlistId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.createdBy;
    }
    
    // User profiles
    match /userprofile/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    }
}

```

## 🐛 Known Issues & Limitations

- **YouTube Rate Limiting**: May encounter rate limits with heavy usage
- **Spotify API Limits**: 100 API calls per hour for search
- **Audio Quality**: Dependent on YouTube source quality
- **Offline Support**: Currently requires internet connection

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Add comprehensive comments for complex logic
- Ensure proper error handling
- Test on both Android and iOS
- Update documentation for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Spotify Web API](https://developer.spotify.com/web-api/) for music metadata
- [Flutter](https://flutter.dev/) framework and community
- [Firebase](https://firebase.google.com/) for backend services
- [YouTube Explode](https://github.com/Hexer10/youtube_explode_dart) for audio streaming

## 📞 Support

If you have any questions or run into issues, please open an issue on GitHub or reach out:

- **Email**: pawanbari127@gmail.com
- **GitHub**: [@Pawanbari](https://github.com/Pawan-bari)

## 🔮 Roadmap

- [ ] Offline music caching
- [ ] Social features (follow friends, shared playlists)
- [ ] Podcast support
- [ ] Enhanced search filters
- [ ] Cross-platform desktop support
- [ ] Integration with more music sources
- [ ] Advanced audio equalizer
- [ ] Lyrics integration

---

⭐ **Star this repository if you found it helpful!**

Built with ❤️ and Flutter
