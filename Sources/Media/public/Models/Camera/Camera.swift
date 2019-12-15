//
//  Camera.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
public struct Camera {
    /// A ready-to-use `SwiftUI` camera view which returns the URL to the
    /// captured media on `success`
    ///
    /// - Parameter completion: a closure which gets the `Result` (`URL` to the captured media on `success` or `Error` on `failure`)
    ///
    public static func view(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        let availableMediaTypes = try (UIImagePickerController.availableMediaTypes(for: .camera) ?? []).map { try UIImagePickerController.MediaType(string: $0) }
        return try ViewCreator.camera(for: Set(availableMediaTypes), completion)
    }
}
#endif
