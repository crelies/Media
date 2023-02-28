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

struct PhotoView: View {
    let photo: Photo

    @State private var data: Data?
    @State private var error: Error?
    @State private var isErrorAlertVisible = false
    @State private var isFavorite = false
    #if !os(macOS)
    @State private var properties: Photo.Properties?
    #endif

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
            // TODO: [example] tvOS 16 example
            #if !os(tvOS) && !os(macOS)
            .onTapGesture {
                Task { @MainActor in
                    let properties = try? await photo.properties()
                    self.properties = properties
                }
            }
            .sheet(
                item: $properties,
                onDismiss: {
                    properties = nil
                },
                content: propertiesScreen
            )
            #endif

            Text(photo.subtypes.map { String(describing: $0) }.joined(separator: ", "))
        }
        .universalNavigationBarItems(trailing: HStack {
            if let metadata = photo.metadata {
                Button(action: {
                    toggleFavoriteState(isFavorite: metadata.isFavorite)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                }
                .alert(isPresented: $isErrorAlertVisible) { errorAlert(error) }
            }

            #if !os(tvOS) && !os(macOS)
            Button(action: share) {
                Text("Share")
            }.sheet(item: $data, onDismiss: {
                data = nil
            }) { data in
                if let image = UniversalImage(data: data) {
                    ActivityView(activityItems: [image], applicationActivities: [])
                }
            }
            #endif
        })
    }
}

private extension PhotoView {
    #if !os(macOS)
    @ViewBuilder
    func propertiesScreen(_ properties: Photo.Properties) -> some View {
        if #available(iOS 14, *) {
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
        #if !os(tvOS)
        .listStyle(InsetGroupedListStyle())
        #endif
    }
    #endif

    func errorAlert(_ error: Error?) -> Alert {
        Alert(title: Text("Error"), message: Text(error?.localizedDescription ?? "An unknown error occurred"), dismissButton: .cancel {
            isErrorAlertVisible = false
        })
    }
}

private extension PhotoView {
    func share() {
        Task { @MainActor in
            do {
                let data = try await self.photo.data()
                self.data = data
            } catch {
                self.error = error
                isErrorAlertVisible = true
            }
        }
    }

    func toggleFavoriteState(isFavorite: Bool) {
        Task { @MainActor in
            do {
                try await photo.favorite(!isFavorite)
                self.isFavorite = photo.metadata?.isFavorite ?? false
            } catch {
                self.error = error
                isErrorAlertVisible = true
            }
        }
    }
}
