import AVFoundation
import Foundation
import ShazamKit

@MainActor
final class AudioRecognitionService: NSObject, ObservableObject {
    @Published private(set) var state: RecognitionState = .idle
    @Published private(set) var isListening = false

    private let audioEngine = AVAudioEngine()
    private let session = SHSession()

    override init() {
        super.init()
        session.delegate = self
    }

    func toggleListening() async {
        if isListening {
            stopListening()
        } else {
            await startListening()
        }
    }

    private func startListening() async {
        state = .requestingPermissions
        let permissionGranted = await requestMicrophonePermission()

        guard permissionGranted else {
            state = .failed(message: "Microphone permission denied")
            return
        }

        do {
            try configureAudioSession()
            installTapAndStartEngine()
            state = .listening
            isListening = true
        } catch {
            state = .failed(message: "Could not start audio engine: \(error.localizedDescription)")
        }
    }

    func stopListening() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        isListening = false
        if case .matched = state {
            return
        }
        state = .idle
    }

    private func installTapAndStartEngine() throws {
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: format) { [weak self] buffer, when in
            self?.session.matchStreamingBuffer(buffer, at: when)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    private func configureAudioSession() throws {
        #if os(iOS)
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [.duckOthers])
        try audioSession.setActive(true, options: [])
        #endif
    }

    private func requestMicrophonePermission() async -> Bool {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            return true
        case .denied:
            return false
        case .undetermined:
            return await AVAudioApplication.requestRecordPermission()
        @unknown default:
            return false
        }
    }
}

extension AudioRecognitionService: SHSessionDelegate {
    nonisolated func session(_ session: SHSession, didFind match: SHMatch) {
        guard
            let item = match.mediaItems.first,
            let title = item.title,
            let artist = item.artist
        else {
            Task { @MainActor in
                self.state = .noMatch
            }
            return
        }

        Task { @MainActor in
            self.state = .matched(song: title, artist: artist)
        }
    }

    nonisolated func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        let message = error?.localizedDescription ?? "No match found yet"
        Task { @MainActor in
            self.state = .failed(message: message)
        }
    }
}
