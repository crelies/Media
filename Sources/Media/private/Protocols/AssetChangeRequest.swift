//
//  AssetChangeRequest.swift
//  Media
//
//  Created by Christian Elies on 12.12.19.
//

import Photos
import UIKit

protocol AssetChangeRequest: class {
    var placeholderForCreatedAsset: PHObjectPlaceholder? { get }
    static func creationRequestForAsset(from image: UIImage) -> Self
    static func creationRequestForAssetFromImage(atFileURL fileURL: URL) -> Self?
}
