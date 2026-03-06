import SwiftUI

struct ContentView: View {
    @StateObject private var recognizer = AudioRecognitionService()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Shazam Replica")
                .font(.largeTitle.bold())

            Text(recognizer.state.title)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Button {
                Task {
                    await recognizer.toggleListening()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.gradient)
                        .frame(width: 190, height: 190)

                    Image(systemName: recognizer.isListening ? "stop.fill" : "mic.fill")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)

            Text(recognizer.isListening ? "Tap to stop" : "Tap to identify a song")
                .foregroundStyle(.secondary)

            Spacer()

            VStack(spacing: 6) {
                Text("Requires microphone access")
                    .font(.footnote)
                Text("Works on iOS and macOS with ShazamKit")
                    .font(.footnote)
            }
            .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
