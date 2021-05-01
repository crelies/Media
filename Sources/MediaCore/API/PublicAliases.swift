//
//  Aliases.swift
//  
//
//  Created by Christian Elies on 30.11.19.
//

import Photos

@available(iOS 10, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public typealias LivePhotoDataCompletion = (Result<LivePhotoData, Error>) -> Void

public typealias MediaType = PHAssetMediaType
public typealias MediaSubtype = PHAssetMediaSubtype

public typealias ResultDataCompletion = (Result<Data, Swift.Error>) -> Void
public typealias ResultGenericCompletion<T> = (Result<T, Swift.Error>) -> Void
public typealias ResultLivePhotoCompletion = (Result<LivePhoto, Error>) -> Void
public typealias ResultLivePhotosCompletion = (Result<[LivePhoto], Error>) -> Void
public typealias RequestLivePhotoResultHandler = (PHLivePhoto?, [AnyHashable : Any]) -> Void
public typealias ResultPHAssetCompletion = (Result<PHAsset, Swift.Error>) -> Void
public typealias ResultPHAssetsCompletion = (Result<[PHAsset], Swift.Error>) -> Void
public typealias ResultPhotoCompletion = (Result<Photo, Swift.Error>) -> Void
public typealias ResultPhotosCompletion = (Result<[Photo], Swift.Error>) -> Void
public typealias ResultURLCompletion = (Result<URL, Swift.Error>) -> Void
public typealias ResultVideoCompletion = (Result<Video, Swift.Error>) -> Void
public typealias ResultVideosCompletion = (Result<[Video], Swift.Error>) -> Void
public typealias ResultVoidCompletion = (Result<Void, Swift.Error>) -> Void
