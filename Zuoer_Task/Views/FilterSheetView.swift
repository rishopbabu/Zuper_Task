//
//  FilterSheetView.swift
//  Zuoer_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import SwiftUI
import ServicesSampleData

struct FilterSheetView: View {
    @Binding var filter: ServiceFilter
    @Environment(\.dismiss) private var dismiss

    private let allStatuses: [ServiceStatus] = [.active, .scheduled, .inProgress, .completed, .urgent]
    private let allPriorities: [Priority] = [.low, .medium, .high, .critical]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(allStatuses, id: \.self) { status in
                        filterRow(
                            label: status.displayLabel,
                            color: status.color,
                            icon: status.systemImage,
                            isSelected: filter.selectedStatuses.contains(status)
                        ) {
                            toggleStatus(status)
                        }
                    }
                } header: {
                    sectionHeader("Status", icon: "bolt.horizontal.circle")
                }

                Section {
                    ForEach(allPriorities, id: \.self) { priority in
                        filterRow(
                            label: priority.displayLabel,
                            color: priority.color,
                            icon: priority.systemImage,
                            isSelected: filter.selectedPriorities.contains(priority)
                        ) {
                            togglePriority(priority)
                        }
                    }
                } header: {
                    sectionHeader("Priority", icon: "flag.circle")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Filter Services")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        filter.reset()
                    }
                    .disabled(!filter.isActive)
                    .tint(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Components

    private func filterRow(
        label: String,
        color: Color,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 22)

                Text(label)
                    .foregroundColor(.primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(color)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.secondary)
            .textCase(nil)
    }

    // MARK: - Actions

    private func toggleStatus(_ status: ServiceStatus) {
        if filter.selectedStatuses.contains(status) {
            filter.selectedStatuses.remove(status)
        } else {
            filter.selectedStatuses.insert(status)
        }
    }

    private func togglePriority(_ priority: Priority) {
        if filter.selectedPriorities.contains(priority) {
            filter.selectedPriorities.remove(priority)
        } else {
            filter.selectedPriorities.insert(priority)
        }
    }
}

#Preview {
    FilterSheetView(filter: .constant(ServiceFilter()))
}
