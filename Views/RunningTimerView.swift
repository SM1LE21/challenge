//
//  RunningTimerView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

struct RunningTimerView: View {
    @Query(sort: \TimerModel.order) private var timers: [TimerModel]
    @State private var currentTimerIndex: Int = 0
    @State private var remainingTime: Int = 0
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("repeatToggleEnabled") private var repeatToggleEnabled = false
    @State private var repeatCurrentTimer: Bool = false

    var body: some View {
        VStack {
            if currentTimerIndex < timers.count {
                Text(timers[currentTimerIndex].name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                Text(formatTime(remainingTime))
                    .font(.system(size: 50, weight: .bold))
                    .padding()

                ProgressView(value: Double(timers[currentTimerIndex].duration - remainingTime), total: Double(timers[currentTimerIndex].duration))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()

                if repeatToggleEnabled {
                    Toggle("Repeat Timer", isOn: $repeatCurrentTimer)
                        .padding()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }

                HStack {
                    Button(action: { toggleTimer() }) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .padding()
                            .background(isRunning ? Color.orange : Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }

                    Button(action: { skipTimer() }) {
                        Image(systemName: "forward.fill")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            } else {
                Text("All timers completed!")
                    .font(.title)
            }
        }
        .onAppear {
            loadInitialTimer()
        }
    }

    private func loadInitialTimer() {
        if !timers.isEmpty {
            currentTimerIndex = 0
            remainingTime = timers[currentTimerIndex].duration
        }
    }

    private func toggleTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                nextTimer()
            }
        }
    }

    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    private func skipTimer() {
        nextTimer()
    }

    private func nextTimer() {
        pauseTimer()
        
        if notificationsEnabled {
            NotificationManager.shared.scheduleNotification(
                title: "Timer Completed",
                body: "\(timers[currentTimerIndex].name) finished!",
                in: 1
            )
        }

        if repeatCurrentTimer {
            remainingTime = timers[currentTimerIndex].duration
            startTimer()
            return
        }

        currentTimerIndex += 1

        if currentTimerIndex < timers.count {
            remainingTime = timers[currentTimerIndex].duration
            startTimer()
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
