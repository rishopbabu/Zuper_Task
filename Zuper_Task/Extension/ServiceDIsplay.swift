//
//  ServiceDIsplay.swift
//  Zuper_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import SwiftUI
import ServicesSampleData

extension ServiceStatus {
    var displayLabel: String {
        switch self {
        case .active:     return "Active"
        case .scheduled:  return "Scheduled"
        case .completed:  return "Completed"
        case .inProgress: return "In Progress"
        case .urgent:     return "Urgent"
        }
    }

    var color: Color {
        switch self {
        case .active:     return Color(red: 0.13, green: 0.55, blue: 0.96)
        case .scheduled:  return Color(red: 0.55, green: 0.27, blue: 0.90)
        case .completed:  return Color(red: 0.18, green: 0.72, blue: 0.51)
        case .inProgress: return Color(red: 0.96, green: 0.62, blue: 0.11)
        case .urgent:     return Color(red: 0.93, green: 0.26, blue: 0.26)
        }
    }
}

extension Priority {
    var displayLabel: String {
        switch self {
        case .low:      return "Low"
        case .medium:   return "Medium"
        case .high:     return "High"
        case .critical: return "Critical"
        }
    }

    var color: Color {
        switch self {
        case .low:      return Color(red: 0.18, green: 0.72, blue: 0.51)
        case .medium:   return Color(red: 0.96, green: 0.76, blue: 0.11)
        case .high:     return Color(red: 0.96, green: 0.62, blue: 0.11)
        case .critical: return Color(red: 0.93, green: 0.26, blue: 0.26)
        }
    }
}
