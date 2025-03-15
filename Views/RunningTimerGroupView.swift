//
//  RunningTimerGroupView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData
import UserNotifications

struct RunningTimerGroupView: View {
    var group: TimerGroup
    
    @State private var currentTimerIndex: Int = 0
    @State private var remainingTime: Int = 0
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("repeatGroupToggleEnabled") private var repeatGroupToggleEnabled = false
    @State private var repeatGroup: Bool = false

    var totalDuration: Int {
        group.timers.reduce(0) { $0 + $1.duration }
    }
    
    // Calculate elapsed time (finished timers + elapsed time of the current one)
    var elapsedTime: Int {
        let finishedDuration = group.timers.prefix(currentTimerIndex).reduce(0) { $0 + $1.duration }
        let currentElapsed = group.timers.indices.contains(currentTimerIndex) ? (group.timers[currentTimerIndex].duration - remainingTime) : 0
        return finishedDuration + currentElapsed
    }
    
    var body: some View {
        VStack {
            if currentTimerIndex < group.timers.count {
                Text(group.timers[currentTimerIndex].name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()
                
                Text(formatTime(remainingTime))
                    .font(.system(size: 50, weight: .bold))
                    .padding()
                
                // Master progress bar showing overall group progress
                VStack {
                    Text("Group Progress: \(formatTime(elapsedTime)) / \(formatTime(totalDuration))")
                        .font(.subheadline)
                    ProgressView(value: Double(elapsedTime), total: Double(totalDuration))
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                }

                if repeatGroupToggleEnabled {
                    Toggle("Repeat Group", isOn: $repeatGroup)
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
                Text("All timers in group completed!")
                    .font(.title)
            }
        }
        .onAppear {
            loadInitialTimer()

            if repeatGroup {
                resetGroup()
            }
        }
    }
    
    private func loadInitialTimer() {
        if !group.timers.isEmpty {
            currentTimerIndex = 0
            remainingTime = group.timers[currentTimerIndex].duration
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
                body: "\(group.timers[currentTimerIndex].name) finished!",
                in: 1
            )
        }
        
        currentTimerIndex += 1
        
        if currentTimerIndex < group.timers.count {
            remainingTime = group.timers[currentTimerIndex].duration
            startTimer()
        } else if repeatGroup {
            resetGroup()
        }
    }

    private func resetGroup() {
        currentTimerIndex = 0
        remainingTime = group.timers[currentTimerIndex].duration
        startTimer()
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
