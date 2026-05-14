//
//  ServiceDetailView.swift
//  Zuper_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import SwiftUI
import MapKit
import ServicesSampleData

struct ServiceDetailView: View {
    let service: Service
    
    // Hardcoded coordinate as per requirements
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private struct MapPin: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    private let pin = MapPin(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Divider()
                    .frame(height: 10)
                
                    locationSection
                    
                    titleView
                    
                    detailsView(
                        image: "user-circle",
                        label: "Customer",
                        value: service.customerName
                    )
                    
                    detailsView(
                        image: "file-text",
                        label: "Description",
                        value: service.description,
                        linelimit: 5
                    )
                    
                    detailsView(
                        image: "clock-hour",
                        label: "Scheduled Time",
                        value: DateFormatterHelper.format(service.scheduledDate)
                    )
                    
                    detailsView(
                        image: "map-pin",
                        label: "Location",
                        value: service.location
                    )
                    
                    detailsView(
                        image: "message",
                        label: "Service Notes",
                        value: service.serviceNotes,
                        linelimit: 5
                    )
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Service Detail")
    }
    
    // MARK: - Subviews
    
    private var locationSection: some View {
        Map(coordinateRegion: $region, annotationItems: [pin]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .frame(height: 180)
        .cornerRadius(12)
        .disabled(false)
    }
    
    private var titleView: some View {
        HStack {
            Text(service.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            statusBadge
        }
    }
    
    private var statusBadge: some View {
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
    
    private func detailsView(image: String, label: String, value: String, linelimit: Int? = 1) -> some View {
        HStack(spacing: 10) {
            Image(image)
                .resizable()
                .frame(width: 26, height: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.body.bold())

                Text(value)
                    .font(.subheadline)
                    .lineLimit(linelimit)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ServiceDetailView(service: SampleData.generateSingleService())
    }
}
