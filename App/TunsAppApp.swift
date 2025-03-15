//
//  TunsAppApp.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData

@main
struct TunsAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: TimerModel.self)
        }
    }
}
