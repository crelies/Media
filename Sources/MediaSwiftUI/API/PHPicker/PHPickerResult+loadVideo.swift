//
//  PHPickerResult+loadVideo.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03.05.21.
//

#if !os(tvOS) && !os(macOS)
import Combine
import PhotosUI

@available(iOS 14, macCatalyst 14, *)
extension PHPickerResult {
    /// <#Description#>
    /// 
    /// - Returns: <#description#>
    public func loadVideo() -> AnyPublisher<URL, Swift.Error> {
        Future { promise in
            let typeIdentifier = UTType.movie.identifier
            guard itemProvider.hasItemConformingToTypeIdentifier(typeIdentifier) else {
                promise(.failure(Error.unknown))
                return
            }

            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error  in
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
#endif
