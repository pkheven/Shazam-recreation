import Foundation

enum RecognitionState: Equatable {
    case idle
    case requestingPermissions
    case listening
    case matched(song: String, artist: String)
    case noMatch
    case failed(message: String)

    var title: String {
        switch self {
        case .idle:
            return "Tap to start listening"
        case .requestingPermissions:
            return "Requesting microphone permission..."
        case .listening:
            return "Listening..."
        case let .matched(song, artist):
            return "\(song) — \(artist)"
        case .noMatch:
            return "No match yet"
        case let .failed(message):
            return message
        }
    }
}
