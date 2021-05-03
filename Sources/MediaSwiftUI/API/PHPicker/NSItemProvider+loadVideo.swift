//
//  NSItemProvider+loadVideo.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03.05.21.
//

import Combine
import Foundation
import PhotosUI

extension NSItemProvider {
    /// Loads a video from the receiving item provider if one is available.
    /// 
    /// - Returns: A publisher which provides a `URL` of the video on `success`.
    public func loadVideo() -> AnyPublisher<URL, Swift.Error> {
        Future { promise in
            let typeIdentifier: String
            if #available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, *) {
                typeIdentifier = UTType.movie.identifier
            } else {
                typeIdentifier = "public.movie"
            }
            guard self.hasItemConformingToTypeIdentifier(typeIdentifier) else {
                promise(.failure(Error.unknown))
                return
            }

            self.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error  in
                if let url = url {
                    let fileManager: FileManager = .default
                    let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
                    let targetLocation = cachesDirectory.appendingPathComponent(url.lastPathComponent)
                    let result: Result<URL, Swift.Error> = Result {
                        if fileManager.fileExists(atPath: targetLocation.path) {
                            let newItemURL = try fileManager.replaceItemAt(targetLocation, withItemAt: url)
                            return newItemURL ?? targetLocation
                        } else {
                            try fileManager.copyItem(at: url, to: targetLocation)
                        }
                        return targetLocation
                    }
                    promise(result)
                } else {
                    let error = error ?? Error.unknown
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
