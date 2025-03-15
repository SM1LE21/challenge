//
//  AddTimerView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData

struct AddTimerView: View {
    @Environment(\.modelContext) private var context
    @Binding var isPresented: Bool

    @State private var timerName: String = ""
    @State private var duration: Int = 300 // Default to 5 min
    @State private var customMinutes: String = ""
    @Query private var timers: [TimerModel]

    let presetDurations: [Int] = [300, 900, 1800, 2700, 3600, 7200] // 5, 15, 30, 45 min, 1h, 2h

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Timer Details")) {
                    TextField("Name", text: $timerName)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(presetDurations, id: \.self) { time in
                                Button(action: {
                                    duration = time
                                    customMinutes = "" // Clear custom input
                                }) {
                                    Text("\(time / 60) min")
                                        .padding(10)
                                        .background(duration == time ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(duration == time ? .white : .black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }

                    TextField("Custom Time (min)", text: $customMinutes)
                        .keyboardType(.numberPad)
                        .onChange(of: customMinutes) { _, newValue in
                            if let customTime = Int(newValue), customTime > 0 {
                                duration = customTime * 60
                            }
                        }
                }
            }
            .navigationTitle("New Timer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTimer()
                    }
                    .disabled(timerName.isEmpty || duration == 0)
                }
            }
        }
    }

    private func saveTimer() {
        let newTimer = TimerModel(
            name: timerName,
            duration: duration,
            order: timers.count
        )
        context.insert(newTimer)
        isPresented = false
    }
}
