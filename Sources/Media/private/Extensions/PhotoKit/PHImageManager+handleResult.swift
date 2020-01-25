//
//  PHImageManager+handleResult.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

extension PHImageManager {
    static func handleResult<T>(result: (item: T?, info: [AnyHashable : Any]?),
                                _ completion: @escaping (Result<T, Swift.Error>) -> Void) {
        if let error = result.info?[PHImageErrorKey] as? Error {
            completion(.failure(error))
        } else if let item = result.item {
            completion(.success(item))
        } else {
            completion(.failure(Media.Error.unknown))
        }
    }
}
