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
    @State private var duration: Int = 0
    @Query private var timers: [TimerModel] 

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Timer Details")) {
                    TextField("Name", text: $timerName)
                    Picker("Duration", selection: $duration) {
                        ForEach(1..<121, id: \.self) { minutes in
                            Text("\(minutes) min").tag(minutes * 60)
                        }
                    }
                }
            }
            .navigationTitle("New Timer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        print("Cancel")
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
        print("Saved the new Timer: ", newTimer)
        isPresented = false
    }
}
