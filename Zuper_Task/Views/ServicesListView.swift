//
//  ServicesListView.swift
//  Zuper_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import SwiftUI
import ServicesSampleData

struct ServicesListView: View {
    @StateObject private var viewModel = ServiceListViewModel()
    @State private var showFilterSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(text: $viewModel.searchText)

                Divider()
                    .frame(height: 10)

                if viewModel.displayedServices.isEmpty {
                    emptyState
                } else {
                    serviceList
                }
            }
            .navigationTitle("Services")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Subviews

    private var serviceList: some View {
        List(viewModel.displayedServices) { service in
            ZStack(alignment: .leading) {
                NavigationLink(value: service) { EmptyView() }
                    .opacity(0)
                ServiceRowView(service: service)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
            )
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationDestination(for: Service.self) { service in
            ServiceDetailView(service: service)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: viewModel.searchText.isEmpty && !viewModel.filter.isActive
                  ? "wrench.and.screwdriver"
                  : "magnifyingglass")
                .font(.system(size: 52, weight: .light))
                .foregroundColor(Color(.tertiaryLabel))

            Text(viewModel.searchText.isEmpty && !viewModel.filter.isActive
                 ? "No Services"
                 : "No Results")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(viewModel.searchText.isEmpty && !viewModel.filter.isActive
                 ? "Pull down to refresh and load services."
                 : "Try a different search term or adjust your filters.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .refreshable {
            await viewModel.refresh()
        }
    }

//    private var filterButton: some View {
//        Button {
//            showFilterSheet = true
//        } label: {
//            ZStack(alignment: .topTrailing) {
//                Image(systemName: "line.3.horizontal.decrease.circle")
//                    .font(.system(size: 20))
//                    .foregroundColor(viewModel.filter.isActive ? .accentColor : .primary)
//                if viewModel.filter.isActive {
//                    Circle()
//                        .fill(Color.accentColor)
//                        .frame(width: 8, height: 8)
//                        .offset(x: 3, y: -3)
//                }
//            }
//        }
//    }
}

#Preview {
    ServicesListView()
}
