//
//  PhotoLibrary.swift
//  Media
//
//  Created by Christian Elies on 07.12.19.
//

import Photos

typealias RequestAuthorizationHandler = (PHAuthorizationStatus) -> Void
typealias PerformChangesCompletionHandler = (Bool, Error?) -> Void

protocol PhotoLibrary: class {
    static func authorizationStatus() -> PHAuthorizationStatus
    static func requestAuthorization(_ handler: @escaping RequestAuthorizationHandler)
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: PerformChangesCompletionHandler?)
}
