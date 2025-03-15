//
//  TimersView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData

struct TimersView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TimerModel.order) private var timers: [TimerModel]

    @State private var isAddingNewTimer = false
    @State private var isRunningTimer = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(timers) { timer in
                        HStack {
                            Text(timer.name)
                                .font(.headline)
                            Spacer()
                            Text("\(formatTime(timer.duration))")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteTimer)
                    .onMove(perform: moveTimer)
                }

                Button(action: { isRunningTimer = true }) {
                    Text("Start Timers")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(timers.isEmpty)
                .sheet(isPresented: $isRunningTimer) {
                    RunningTimerView()
                }
            }
            .navigationTitle("Timers")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingNewTimer = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewTimer) {
                AddTimerView(isPresented: $isAddingNewTimer)
            }
        }
    }

    private func deleteTimer(at offsets: IndexSet) {
        for index in offsets {
            context.delete(timers[index])
        }
    }

    private func moveTimer(from source: IndexSet, to destination: Int) {
        var reorderedTimers = timers
        reorderedTimers.move(fromOffsets: source, toOffset: destination)
        
        for (index, timer) in reorderedTimers.enumerated() {
            timer.order = index
        }

        try? context.save()
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
