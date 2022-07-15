//
//  NSItemProvider+loadLivePhoto.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03.05.21.
//

import Combine
import Foundation
import Photos

extension NSItemProvider {
    /// Loads a live photo from the receiving item provider if one is available.
    ///
    /// - Returns: A publisher which provides a `PHLivePhoto` on `success`.
    public func loadLivePhoto() -> AnyPublisher<PHLivePhoto, Swift.Error> {
        Future { promise in
            guard self.canLoadObject(ofClass: PHLivePhoto.self) else {
                promise(.failure(Error.couldNotLoadObject(underlying: Error.unknown)))
                return
            }

            self.loadObject(ofClass: PHLivePhoto.self) { livePhoto, error in
                if let error = error {
                    promise(.failure(Error.couldNotLoadObject(underlying: error)))
                } else if let livePhoto = livePhoto {
                    promise(.success(livePhoto as! PHLivePhoto))
                } else {
                    promise(.failure(Error.unknown))
                }
            }
        }.eraseToAnyPublisher()
    }
}
