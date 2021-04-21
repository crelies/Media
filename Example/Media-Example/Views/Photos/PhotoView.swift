//
//  PhotoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MapKit
import MediaCore
import SwiftUI

extension Photo.Properties: Identifiable {
    public var id: String { "\(exif.dateTimeOriginal ?? "")_\(UUID().uuidString)" }
}

extension Data: Identifiable {
    public var id: Self { self }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: Double { latitude + longitude }
}

struct PhotoView: View {
    let photo: Photo

    @State private var data: Data?
    @State private var error: Error?
    @State private var isErrorAlertVisible = false
    @State private var isFavorite = false
    @State private var properties: Photo.Properties?

    var body: some View {
        VStack(spacing: 16) {
            photo.view { image in
                image
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
            .onAppear {
                isFavorite = photo.metadata?.isFavorite ?? false
            }
            .onTapGesture {
                photo.properties { result in
                    switch result {
                    case .success(let properties):
                        self.properties = properties
                    case .failure:
                        properties = nil
                    }
                }
            }
            .sheet(
                item: $properties,
                onDismiss: {
                    properties = nil
                },
                content: propertiesScreen
            )

            Text(photo.subtypes.map { String(describing: $0) }.joined(separator: ", "))
        }
        .navigationBarItems(trailing: HStack {
            if let metadata = photo.metadata {
                Button(action: {
                    toggleFavoriteState(isFavorite: metadata.isFavorite)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                }
                .alert(isPresented: $isErrorAlertVisible) { errorAlert(error) }
            }

            Button(action: share) {
                Text("Share")
            }.sheet(item: $data, onDismiss: {
                data = nil
            }) { data in
                if let image = UIImage(data: data) {
                    ActivityView(activityItems: [image], applicationActivities: [])
                }
            }
        })
    }
}

private extension PhotoView {
    @ViewBuilder func propertiesScreen(_ properties: Photo.Properties) -> some View {
        if #available(iOS 14.0, *) {
            if let location = properties.gps.location {
                Map(
                    coordinateRegion: .constant(
                        .init(
                            center: .init(
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude
                            ),
                            latitudinalMeters: 5000,
                            longitudinalMeters: 5000
                        )
                    ),
                    annotationItems: [location.coordinate]
                ) { item in
                    MapMarker(coordinate: item)
                }
            }
        }

        List {
            Section {
                Text(String(describing: properties.exif))
            }

            Section {
                Text(String(describing: properties.gps))
            }

            Section {
                Text(String(describing: properties.tiff))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    func errorAlert(_ error: Error?) -> Alert {
        Alert(title: Text("Error"), message: Text(error?.localizedDescription ?? "An unknown error occurred"), dismissButton: .cancel {
            isErrorAlertVisible = false
        })
    }
}

private extension PhotoView {
    func share() {
        photo.data { result in
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let error):
                self.error = error
            }
        }
    }

    func toggleFavoriteState(isFavorite: Bool) {
        photo.favorite(!isFavorite) { result in
            switch result {
            case .success:
                self.isFavorite = photo.metadata?.isFavorite ?? false
            case .failure(let error):
                self.error = error
                isErrorAlertVisible = true
            }
        }
    }
}
