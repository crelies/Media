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

// TODO: public
public protocol AssetChangeRequest: class {
    var placeholderForCreatedAsset: PHObjectPlaceholder? { get }
    #if canImport(UIKit)
    static func creationRequestForAsset(from image: UIImage) -> Self
    #endif
    static func creationRequestForAssetFromImage(atFileURL fileURL: URL) -> Self?
    static func deleteAssets(_ assets: NSFastEnumeration)
}
