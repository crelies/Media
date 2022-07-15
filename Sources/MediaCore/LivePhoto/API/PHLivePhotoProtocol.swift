//
//  PHLivePhotoProtocol.swift
//  Media
//
//  Created by Christian Elies on 15.12.19.
//

import Photos
#if canImport(UIKit)
import UIKit
#endif

/// Defines requirements for a `PHLivePhoto` instance
///
/// Internally used to enable mocking and unit testing
///
public protocol PHLivePhotoProtocol {
    /// The size, in pixels, of the Live Photo.
    var size: CGSize { get }
    #if canImport(UIKit)
    /// Asynchronously loads a Live Photo from the specified resource files.
    ///
    /// - Parameters:
    ///   - fileURLs: An array of URLs containing the resource URLs that constitute a Live Photo, as obtained using the PHAssetResource class.
    ///   - image: A static image to represent the Live Photo before its full content has been loaded and validated.
    ///   - targetSize: The target size of Live Photo to be returned. Pass CGSizeZero to obtain the requested Live Photo at its original size.
    ///   - contentMode: An option for how to fit the image to the aspect ratio of the requested size. For details, see PHLivePhoto.
    ///   - resultHandler: A block to be called when image loading is complete, providing the requested Live Photo or information about the status of the request.
    ///
    ///         The block takes the following parameters:
    ///
    ///             result
    ///                 The requested Live Photo object.
    ///
    ///             info
    ///                 A dictionary providing information about the status of the request. See PHLivePhoto for possible keys and values.
    ///
    static func request(withResourceFileURLs fileURLs: [URL], placeholderImage image: UIImage?, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping RequestLivePhotoResultHandler) -> PHLivePhotoRequestID
    #endif
    /// Cancels an asynchronous request
    ///
    /// - Parameter requestID: The numeric identifier of the request to be canceled.
    ///
    static func cancelRequest(withRequestID requestID: PHLivePhotoRequestID)
}
