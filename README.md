# Focus Timer

A macOS menu bar Pomodoro timer built with SwiftUI.

## Features

- Lives in the menu bar — shows the countdown at a glance
- Standard Pomodoro intervals: 25 min focus, 5 min short break, 15 min long break
- Automatically advances to the next phase when a session ends
- 4-dot progress indicator tracks sessions in the current cycle
- macOS notifications and a beep sound at each phase transition
- Controls: Start/Pause (Space), Reset, Skip, Reset All

## Requirements

- macOS 13 Ventura or later
- Xcode 14 or later

## Getting Started

```bash
git clone https://github.com/etxnija/focus-timer.git
cd focus-timer
open FocusTimer/FocusTimer.xcodeproj
```

Build and run with `Cmd+R`. The app will appear in your menu bar.

## Project Structure

```
FocusTimer/
├── FocusTimerApp.swift   # App entry point, menu bar setup
├── ContentView.swift     # Menu bar popover UI
└── PomodoroTimer.swift   # Timer logic and phase management
```
