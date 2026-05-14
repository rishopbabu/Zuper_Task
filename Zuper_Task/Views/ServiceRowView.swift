//
//  ServiceRowView.swift
//  Zuper_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import SwiftUI
import ServicesSampleData

struct ServiceRowView: View {
    let service: Service

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title row: title on left, status badge on far right
            HStack(alignment: .center, spacing: 8) {
                Text(service.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Spacer()
                priorityBadge
            }

            // Customer name row
            HStack(spacing: 6) {
                Image("user-circle")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text(service.customerName)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            // Description row
            HStack(alignment: .top, spacing: 6) {
                Image("file-text")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.top, 1)
                Text(service.description)
                    .font(.system(size: 13))
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(2)
            }

            // Bottom row: priority + date
            HStack {
                statusBadge
                Spacer()
                dateLabel
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }

    // MARK: - Subviews

    public var statusBadge: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerSize: .zero)
                .fill(service.status.color.opacity(0.5))
                .frame(width: 20, height: 20)
                .cornerRadius(4.5)
            Text(service.status.displayLabel)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(service.status.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background(service.status.color.opacity(0.1))
        .clipShape(Capsule())
    }

    private var priorityBadge: some View {
        HStack {
            Circle()
                .fill(service.priority.color)
                .frame(width: 10, height: 10)
        }
    }
    
    private var dateLabel: some View {
        HStack(spacing: 4) {
            Text(DateFormatterHelper.format(service.scheduledDate))
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ServiceRowView(service: SampleData.generateSingleService())
        .padding(.horizontal)
}
