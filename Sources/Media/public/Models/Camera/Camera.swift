//
//  Camera.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI)
import SwiftUI
import UIKit

@available(iOS 13, OSX 10.15, *)
public struct Camera {
    public static func view(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        let availableMediaTypes = try (UIImagePickerController.availableMediaTypes(for: .camera) ?? []).map { try UIImagePickerController.MediaType(string: $0) }
        return try ViewCreator.camera(for: availableMediaTypes, completion)
    }
}
#endif
