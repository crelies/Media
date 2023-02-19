//
//  CLLocationCoordinate2D+Identifiable.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Identifiable {
    public var id: Double { latitude + longitude }
}
