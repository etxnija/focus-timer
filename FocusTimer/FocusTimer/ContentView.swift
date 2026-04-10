import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoro: PomodoroTimer

    var body: some View {
        VStack(spacing: 20) {
            phaseHeader
            sessionDots
            timerDisplay
            controls
            Divider()
            quitButton
        }
        .padding(24)
        .frame(width: 280)
    }

    // MARK: - Subviews

    private var phaseHeader: some View {
        HStack(spacing: 6) {
            Image(systemName: pomodoro.phase.symbol)
            Text(pomodoro.phase.rawValue)
                .fontWeight(.medium)
        }
        .foregroundColor(.secondary)
    }

    private var sessionDots: some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(pomodoro.sessionDots[i] ? Color.red : Color.secondary.opacity(0.25))
                    .frame(width: 10, height: 10)
            }
        }
    }

    private var timerDisplay: some View {
        Text(pomodoro.menuBarLabel)
            .font(.system(size: 56, weight: .thin, design: .monospaced))
            .monospacedDigit()
    }

    private var controls: some View {
        VStack(spacing: 10) {
            // Primary: start / pause
            Button(action: primaryAction) {
                Text(pomodoro.isRunning ? "Pause" : "Start")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.space, modifiers: [])

            // Secondary row
            HStack(spacing: 8) {
                Button("Reset") { pomodoro.reset() }
                    .frame(maxWidth: .infinity)
                Button("Skip") { pomodoro.skip() }
                    .frame(maxWidth: .infinity)
                Button("Reset All") { pomodoro.resetAll() }
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.regular)
            .buttonStyle(.bordered)
        }
    }

    private var quitButton: some View {
        Button("Quit Focus Timer") {
            NSApplication.shared.terminate(nil)
        }
        .foregroundColor(.secondary)
        .buttonStyle(.plain)
        .font(.footnote)
    }

    // MARK: - Helpers

    private func primaryAction() {
        pomodoro.isRunning ? pomodoro.pause() : pomodoro.start()
    }
}
