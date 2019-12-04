//
//  PHAssetMediaSubtype+Hashable.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Photos

extension PHAssetMediaSubtype: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
}
