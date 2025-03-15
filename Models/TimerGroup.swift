//
//  TimerGroup.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftData
import Foundation

@Model
class TimerGroup: Identifiable {
    var id: UUID
    var name: String
    var timers: [TimerModel]

    init(name: String, timers: [TimerModel]) {
        self.id = UUID()
        self.name = name
        self.timers = timers
    }
}
