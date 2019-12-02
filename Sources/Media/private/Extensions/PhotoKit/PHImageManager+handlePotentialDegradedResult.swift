//
//  PHImageManager+handlePotentialDegradedResult.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

extension PHImageManager {
    static func handlePotentialDegradedResult<T>(_ result: (item: T?, info: [AnyHashable : Any]?),
                                                 _ completion: @escaping (Result<Media.DisplayRepresentation<T>, Error>) -> Void) {
        if let error = result.info?[PHImageErrorKey] as? Error {
            completion(.failure(error))
        } else if let item = result.item {
            let imageResultIsDegraded = result.info?[PHImageResultIsDegradedKey] as? NSNumber
            switch imageResultIsDegraded?.boolValue {
                case .none:
                    let displayRepresentation = Media.DisplayRepresentation(value: item, quality: .high)
                    completion(.success(displayRepresentation))
                case .some(let booleanValue):
                    if booleanValue {
                        let displayRepresentation = Media.DisplayRepresentation(value: item, quality: .low)
                        completion(.success(displayRepresentation))
                    } else {
                        let displayRepresentation = Media.DisplayRepresentation(value: item, quality: .high)
                        completion(.success(displayRepresentation))
                    }
            }
        } else {
            completion(.failure(MediaError.unknown))
        }
    }
}
