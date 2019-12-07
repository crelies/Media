//
//  PhotoLibrary.swift
//  Media
//
//  Created by Christian Elies on 07.12.19.
//

import Photos

protocol PhotoLibrary: class {
    static func authorizationStatus() -> PHAuthorizationStatus
    static func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void)
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)?)
}
