//
//  NSItemProvider+loadImage.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 14.10.20.
//

#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
import Combine
import Foundation
import MediaCore
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@available(macOS 13, *)
extension NSItemProvider {
    /// Loads an image from the receiving item provider if one is available.
    ///
    /// - Returns: A publisher which provides an `UniversalImage` on `success`.
    public func loadImage() -> AnyPublisher<UniversalImage, Swift.Error> {
        Future { promise in
            guard self.canLoadObject(ofClass: UniversalImage.self) else {
                promise(.failure(Error.couldNotLoadObject(underlying: Error.unknown)))
                return
            }

            self.loadObject(ofClass: UniversalImage.self) { newImage, error in
                if let error = error {
                    promise(.failure(Error.couldNotLoadObject(underlying: error)))
                } else if let newImage = newImage {
                    promise(.success(newImage as! UniversalImage))
                } else {
                    promise(.failure(Error.unknown))
                }
            }
        }.eraseToAnyPublisher()
    }
}
#endif
