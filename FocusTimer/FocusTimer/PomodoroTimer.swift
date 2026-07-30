import Foundation
import AppKit
import UserNotifications

enum TimerPhase: String {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    var duration: Int {
        switch self {
        case .focus:       return 25 * 60
        case .shortBreak:  return 5 * 60
        case .longBreak:   return 15 * 60
        }
    }

    var symbol: String {
        switch self {
        case .focus:       return "timer"
        case .shortBreak:  return "cup.and.saucer"
        case .longBreak:   return "figure.walk"
        }
    }
}

class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: Int
    @Published var phase: TimerPhase = .focus
    @Published var isRunning: Bool = false
    @Published var completedSessions: Int = 0

    private var timer: Timer?

    init() {
        self.timeRemaining = TimerPhase.focus.duration
        requestNotificationPermission()
    }

    var menuBarLabel: String {
        let m = timeRemaining / 60
        let s = timeRemaining % 60
        return String(format: "%d:%02d", m, s)
    }

    // Sessions within the current cycle (0–3)
    var sessionDots: [Bool] {
        let done = completedSessions % 4
        return (0..<4).map { $0 < done }
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        pause()
        timeRemaining = phase.duration
    }

    func resetAll() {
        pause()
        phase = .focus
        completedSessions = 0
        timeRemaining = TimerPhase.focus.duration
    }

    func skip() {
        pause()
        advance(autoStart: false)
    }

    // MARK: - Private

    private func tick() {
        if timeRemaining > 1 {
            timeRemaining -= 1
        } else {
            timeRemaining = 0
            advance(autoStart: true)
        }
    }

    private func advance(autoStart: Bool) {
        pause()

        switch phase {
        case .focus:
            completedSessions += 1
            if completedSessions % 4 == 0 {
                phase = .longBreak
                notify(title: "Long break — 15 min", body: "4 sessions done. Well done.")
            } else {
                phase = .shortBreak
                notify(title: "Short break — 5 min", body: "Stretch, breathe, hydrate.")
            }
        case .shortBreak, .longBreak:
            phase = .focus
            notify(title: "Focus — 25 min", body: "Back to it.")
        }

        timeRemaining = phase.duration
        if autoStart && phase != .focus { start() }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private func notify(title: String, body: String) {
        NSSound.beep()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(req)
    }
}
