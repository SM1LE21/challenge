//
//  MainView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Manage Your Timers")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)

                NavigationLink("Go to Timers", destination: TimersView())
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
