//
//  PHPickerResult+loadLivePhoto.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03.05.21.
//

#if !os(tvOS) && (!os(macOS) || targetEnvironment(macCatalyst))
import Combine
import PhotosUI

@available(iOS 14, macCatalyst 14, *)
extension PHPickerResult {
    /// <#Description#>
    /// 
    /// - Returns: <#description#>
    public func loadLivePhoto() -> AnyPublisher<PHLivePhoto, Swift.Error> {
        Future { promise in
            guard itemProvider.canLoadObject(ofClass: PHLivePhoto.self) else {
                promise(.failure(Error.couldNotLoadObject(underlying: Error.unknown)))
                return
            }

            itemProvider.loadObject(ofClass: PHLivePhoto.self) { livePhoto, error in
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
#endif
