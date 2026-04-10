import SwiftUI

@main
struct FocusTimerApp: App {
    @StateObject private var pomodoro = PomodoroTimer()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(pomodoro)
        } label: {
            Text(pomodoro.menuBarLabel)
                .monospacedDigit()
        }
        .menuBarExtraStyle(.window)
    }
}
