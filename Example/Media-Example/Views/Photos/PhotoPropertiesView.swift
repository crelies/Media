//
//  PhotoPropertiesView.swift
//  Media-Example
//
//  Created by Christian Elies on 01.03.23.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

#if canImport(UIKit)
import MapKit
import MediaCore
import SwiftUI

struct PhotoPropertiesView: View {
    let properties: Photo.Properties

    var body: some View {
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
        .insetGroupedListStyle()
    }
}
#endif
