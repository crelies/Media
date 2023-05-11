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

    /// A wrapper type which is used by the internal implementation
    /// to access the underlying `PHAsset` object
    ///
    /// Among others it's used to implement a default `delete` method
    /// for objects conforming to this protocol
    ///
    var phAssetWrapper: PHAssetWrapper { get set }

    /// Identifier resolves to the local identifier of the underlying
    /// `PHAsset`
    ///
    var identifier: Media.Identifier<Self>? { get }

    /// Returns the type for a specific Media class
    ///
    static var type: MediaType { get }

    /// Initializes a media object using the given `PHAsset` object
    ///
    /// Because this Swift package is *just* a convenience wrapper around
    /// `PhotoKit` this initializer is all you need to setup up
    /// a media object
    ///
    /// - Parameter phAsset: an object representing photo library media
    ///
    init(phAsset: PHAsset)

    /// Find a media object with the given identifier
    ///
    /// - Parameter identifier: the identifier of a media object
    ///
    static func with(identifier: Media.Identifier<Self>) throws -> Self?

    /// Deletes the receiving media object from the photo library
    ///
    /// - Parameter completion: returns `Void` on `success` or an `Error` on `failure`
    ///
    func delete(completion: @escaping ResultGenericCompletion<Self>)

    /// Deletes the receiving media object from the photo library
    ///
    mutating func delete() async throws
}

extension MediaProtocol {
    /// A unique identifier, currently the `localIdentifier` of the `phAsset`
    ///
    public var identifier: Media.Identifier<Self>? {
        guard let phAsset = phAssetWrapper.value else { return nil }
        return Media.Identifier(stringLiteral: phAsset.localIdentifier)
    }
}

extension MediaProtocol {
    static var assetChangeRequest: AssetChangeRequest.Type { PHAssetChangeRequest.self }

    /// Deletes the receiver if the access to the photo library is allowed
    ///
    /// Hint: asynchronously
    /// - Parameter completion: a closure which get's the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    public func delete(completion: @escaping ResultGenericCompletion<Self>) {
        guard let phAsset = phAssetWrapper.value else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        var value = self

        PHChanger.request({
            let phAssets: NSArray = [phAsset]
            Self.assetChangeRequest.deleteAssets(phAssets)
            return nil
        }) { result in
            switch result {
            case .success:
                value.phAssetWrapper = .init(value: nil)
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Deletes the receiver if the access to the photo library is allowed
    ///
    public mutating func delete() async throws {
        guard let phAsset = phAssetWrapper.value else {
            throw Media.Error.noUnderlyingPHAssetFound
        }

        try await PHChanger.request({
            let phAssets: NSArray = [phAsset]
            Self.assetChangeRequest.deleteAssets(phAssets)
            return nil
        })

        self.phAssetWrapper = .init(value: nil)
    }
}
