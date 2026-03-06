# Shazam Replica (iOS + macOS)

A SwiftUI app that mimics the core Shazam experience:

- Tap once to start listening with the microphone.
- The app streams audio to ShazamKit.
- If a song is recognized, it shows track title and artist.
- Works from one target on **iPhone** and **Mac**.

## Project structure

- `ShazamReplica.xcodeproj` — Xcode project
- `ShazamReplica/ShazamReplicaApp.swift` — app entry point
- `ShazamReplica/ContentView.swift` — UI
- `ShazamReplica/Services/AudioRecognitionService.swift` — AVAudioEngine + ShazamKit logic
- `ShazamReplica/Models/RecognitionState.swift` — view state model

## Requirements

- Xcode 16+
- iOS 17+ (device recommended for real recognition)
- macOS 14+
- Microphone permission granted at runtime

## Run on iPhone

1. Open `ShazamReplica.xcodeproj` in Xcode.
2. In **Signing & Capabilities**, set your Apple Team.
3. Connect iPhone, choose your device as run destination.
4. Build and run.
5. Tap the big button and play music nearby.

## Run on Mac

1. Open `ShazamReplica.xcodeproj`.
2. Select **My Mac** as run destination.
3. Build and run.
4. Allow microphone access when prompted.

## Notes

- The app is intentionally minimal and focused on recognition.
- You can further extend this with match history, Apple Music deep links, haptics, and animated effects.
