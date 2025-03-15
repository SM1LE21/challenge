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

    var body: some View {
        VStack {
            if currentTimerIndex < timers.count {
                Text(timers[currentTimerIndex].name)
                    .font(.largeTitle)
                    .padding()

                Text(formatTime(remainingTime))
                    .font(.system(size: 50, weight: .bold))
                    .padding()

                ProgressView(value: Double(timers[currentTimerIndex].duration - remainingTime), total: Double(timers[currentTimerIndex].duration))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()

                HStack {
                    Button(action: { startTimer() }) {
                        Image(systemName: "play.fill")
                            .padding()
                            .background(isRunning ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .disabled(isRunning)

                    Button(action: { pauseTimer() }) {
                        Image(systemName: "pause.fill")
                            .padding()
                            .background(isRunning ? Color.orange : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .disabled(!isRunning)
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

    private func nextTimer() {
        pauseTimer()
        
        if notificationsEnabled {
            NotificationManager.shared.scheduleNotification(
                title: "Timer Completed",
                body: "\(timers[currentTimerIndex].name) finished!",
                in: 1
            )
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
