//
//  TimerGroupsView.swift
//  TunsApp
//
//  Created by Tun Keltesch on 15/03/2025.
//

import SwiftUI
import SwiftData

struct TimerGroupsView: View {
    @Environment(\.modelContext) private var context
    @Query private var groups: [TimerGroup]

    @State private var isAddingNewGroup = false

    var body: some View {
        List {
            ForEach(groups) { group in
                NavigationLink(destination: RunningTimerGroupView(group: group)) {
                    Text(group.name)
                        .font(.headline)
                }
            }
            .onDelete(perform: deleteGroup)
        }
        .navigationTitle("Timer Groups")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isAddingNewGroup = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingNewGroup) {
            AddGroupView(isPresented: $isAddingNewGroup)
        }
    }

    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            context.delete(groups[index])
        }
    }
}
