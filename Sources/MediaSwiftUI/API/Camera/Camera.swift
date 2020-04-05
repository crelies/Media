//
//  Camera.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import MediaCore
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
/// Type which provides a ready-to-use SwiftUI view
///
public struct Camera {
    public typealias ResultCameraResultCompletion = (Swift.Result<Camera.Result, Swift.Error>) -> Void

    /// A ready-to-use `SwiftUI` camera view which returns the URL to the
    /// captured media on `success`
    ///
    /// - Parameter completion: a closure which gets the `Result` (`CameraResult` on `success` or `Error` on `failure`)
    ///
    public static func view(_ completion: @escaping ResultCameraResultCompletion) throws -> some View {
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        let mediaTypes = try availableMediaTypes.map { try UIImagePickerController.MediaType(string: $0) }
        return try ViewCreator.camera(for: Set(mediaTypes), completion)
    }
}
#endif
