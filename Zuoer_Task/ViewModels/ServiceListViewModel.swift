//
//  ServiceListViewModel.swift
//  Zuoer_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import Foundation
import Combine
import ServicesSampleData

@MainActor
final class ServiceListViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var searchText: String = ""
    @Published var filter: ServiceFilter = ServiceFilter()
    @Published var displayedServices: [Service] = []
    @Published var isRefreshing: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupPipeline()
        loadServices()
    }

    // MARK: - Combine pipeline: debounce search + filter applied together
    private func setupPipeline() {
        let debouncedSearch = $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()

        Publishers.CombineLatest3($services, debouncedSearch, $filter)
            .map { services, query, filter in
                var result = filter.apply(to: services)
                if !query.isEmpty {
                    result = result.filter {
                        $0.title.localizedCaseInsensitiveContains(query) ||
                        $0.customerName.localizedCaseInsensitiveContains(query) ||
                        $0.description.localizedCaseInsensitiveContains(query)
                    }
                }
                // Sort: Today → Yesterday → all other dates (ascending)
                result.sort { lhs, rhs in
                    let lhsDate = Self.parseDate(lhs.scheduledDate) ?? .distantFuture
                    let rhsDate = Self.parseDate(rhs.scheduledDate) ?? .distantFuture
                    let lhsGroup = Self.sortGroup(for: lhsDate)
                    let rhsGroup = Self.sortGroup(for: rhsDate)
                    if lhsGroup != rhsGroup { return lhsGroup < rhsGroup }
                    return lhsDate < rhsDate
                }
                return result
            }
            .receive(on: RunLoop.main)
            .assign(to: &$displayedServices)
    }

    // MARK: - Date parsing for sort
    private static let iso8601Parser: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static func parseDate(_ string: String) -> Date? {
        iso8601Parser.date(from: string)
    }

    // Group 0 = today, 1 = tomorrow, 2 = yesterday, 3 = other dates (dd/MM/yyyy)
    private static func sortGroup(for date: Date) -> Int {
        let cal = Calendar.current
        if cal.isDateInToday(date)     { return 0 }
        if cal.isDateInTomorrow(date)  { return 1 }
        if cal.isDateInYesterday(date) { return 2 }
        return 3
    }

    // MARK: - Data loading
    func loadServices() {
        services = SampleData.generateServices()
    }

    func refresh() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 2_500_000_000)
        services = SampleData.generateServices()
        isRefreshing = false
    }
}
