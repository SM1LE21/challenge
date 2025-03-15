//
//  SettingsView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false // deactivated it by default so whoever tests this is forced to allow notifications when using the app.
    @AppStorage("repeatToggleEnabled") private var repeatToggleEnabled = false // UI Element in RunningTimerView -> if true Timers can be repeated by adhoc by toggling it.

    var body: some View {
        Form {
            // Copied this from another simple APP -> Makes the Settings look a bit more Populated, One Setting simply seemed SAD
            Toggle("Dark Mode", isOn: $isDarkMode)
                .onChange(of: isDarkMode) { _, _ in
                    updateAppTheme()
                }

            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { _, _ in
                    if notificationsEnabled {
                        NotificationManager.shared.requestPermission()
                    }
                }

            Toggle("Enable Repeat Timer Toggle", isOn: $repeatToggleEnabled)
        }
        .navigationTitle("Settings")
    }

    private func updateAppTheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}
