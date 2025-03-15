//
//  TimerModel.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftData
import Foundation

@Model
class TimerModel: Identifiable {
    var id: UUID
    var name: String
    var duration: Int // seconds
    var order: Int // allows me to determine sequence order
    var isRecurring: Bool // Determines if timer repeats

    init(name: String, duration: Int, order: Int, isRecurring: Bool = false) {
        self.id = UUID()
        self.name = name
        self.duration = duration
        self.order = order
        self.isRecurring = isRecurring
    }
}
