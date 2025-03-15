//
//  AddGroupView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var context
    @Binding var isPresented: Bool
    @Query private var timers: [TimerModel]
    
    @State private var groupName: String = ""
    @State private var selectedTimerIDs: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Details")) {
                    TextField("Group Name", text: $groupName)
                }
                
                Section(header: Text("Select Timers")) {
                    List(timers) { timer in
                        MultipleSelectionRow(timer: timer, isSelected: selectedTimerIDs.contains(timer.id)) {
                            if selectedTimerIDs.contains(timer.id) {
                                selectedTimerIDs.remove(timer.id)
                            } else {
                                selectedTimerIDs.insert(timer.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Timer Group")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGroup()
                    }
                    .disabled(groupName.isEmpty || selectedTimerIDs.isEmpty)
                }
            }
        }
    }
    
    private func saveGroup() {
        // Create a new group with an empty timers array.
        let newGroup = TimerGroup(name: groupName, timers: [])
        context.insert(newGroup)
        
        // Fetch the selected timers from the current context.
        let selectedTimers = timers.filter { selectedTimerIDs.contains($0.id) }
        
        // Append each selected timer to the new group's timers array.
        for timer in selectedTimers {
            newGroup.timers.append(timer)
        }
        
        isPresented = false
    }
}

struct MultipleSelectionRow: View {
    var timer: TimerModel
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(timer.name)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
