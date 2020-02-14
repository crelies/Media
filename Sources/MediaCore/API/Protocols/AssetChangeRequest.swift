//
//  AssetChangeRequest.swift
//  Media
//
//  Created by Christian Elies on 12.12.19.
//

import Photos
#if canImport(UIKit)
import UIKit
#endif

/// Defines the requirements for an
/// asset change request
///
public protocol AssetChangeRequest: class {
    /// A placeholder object for the asset that the change request creates.
    var placeholderForCreatedAsset: PHObjectPlaceholder? { get }
    #if canImport(UIKit)
    /// Creates a request for adding a new image asset to the Photos library.
    ///
    /// - Parameter image: An image.
    ///
    static func creationRequestForAsset(from image: UIImage) -> Self
    #endif
    /// Creates a request for adding a new image asset to the Photos library,
    /// using the image file at the specified URL.
    ///
    /// - Parameter fileURL: A URL for an image file.
    ///
    static func creationRequestForAssetFromImage(atFileURL fileURL: URL) -> Self?
    /// Requests that the specified assets be deleted.
    ///
    /// - Parameter assets: An array of PHAsset objects to be deleted.
    ///
    static func deleteAssets(_ assets: NSFastEnumeration)
}
