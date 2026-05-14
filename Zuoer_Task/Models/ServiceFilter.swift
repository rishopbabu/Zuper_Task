//
//  ServiceFilter.swift
//  Zuoer_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import Foundation
import ServicesSampleData

struct ServiceFilter {
    var selectedStatuses: Set<ServiceStatus> = []
    var selectedPriorities: Set<Priority> = []

    var isActive: Bool {
        !selectedStatuses.isEmpty || !selectedPriorities.isEmpty
    }

    func apply(to services: [Service]) -> [Service] {
        services.filter { service in
            let statusMatch = selectedStatuses.isEmpty || selectedStatuses.contains(service.status)
            let priorityMatch = selectedPriorities.isEmpty || selectedPriorities.contains(service.priority)
            return statusMatch && priorityMatch
        }
    }

    mutating func reset() {
        selectedStatuses = []
        selectedPriorities = []
    }
}
