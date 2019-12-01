//
//  PHChanger.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct PHChanger {
    static func request(_ request: @escaping () -> PHChangeRequest?,
                        _ completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            _ = request()
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        })
    }
}
