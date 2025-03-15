//
//  SettingsView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hapticFeedback") private var hapticFeedback = true

    var body: some View {
        Form {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .onChange(of: isDarkMode) {
                    updateAppTheme()
                }

            Toggle("Enable Haptic Feedback", isOn: $hapticFeedback)
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
