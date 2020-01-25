//
//  MediaProtocol.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Defines the requirements for a specific `Media`,
/// like a `LivePhoto` or `Video`
///
public protocol MediaProtocol {
    associatedtype MediaSubtype: MediaSubtypeProvider
    associatedtype MediaFileType: RawRepresentable where MediaFileType.RawValue == String, MediaFileType: CaseIterable, MediaFileType: PathExtensionsProvider

    var phAsset: PHAsset { get }
    /// Identifier resolves to the local identifier of the underlying
    /// `PHAsset`
    ///
    var identifier: Media.Identifier<Self> { get }
    static var type: MediaType { get }

    init(phAsset: PHAsset)

    static func with(identifier: Media.Identifier<Self>) throws -> Self?

    func delete(completion: @escaping (Result<Void, Error>) -> Void)
}

extension MediaProtocol {
    /// A unique identifier, currently the `localIdentifier` of the `phAsset`
    ///
    public var identifier: Media.Identifier<Self> { Media.Identifier(stringLiteral: phAsset.localIdentifier) }
}

extension MediaProtocol {
    /// Deletes the receiver if the access to the photo library is allowed
    ///
    /// Hint: asynchronously
    /// - Parameter completion: a closure which get's the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    public func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        // TODO: what should we do with the asset reference?
        PHChanger.request({
            let phAssets: NSArray = [self.phAsset]
            PHAssetChangeRequest.deleteAssets(phAssets)
            return nil
        }, completion)
    }
}
