//
//  MediaCoreAliases.swift
//  MediaCore
//
//  Created by Christian Elies on 30.11.19.
//

import Photos

#if !os(macOS)
@available(iOS 10, *)
@available(tvOS, unavailable)
public typealias LivePhotoDataCompletion = (Result<CapturedPhotoData, Error>) -> Void
#else
public typealias LivePhotoDataCompletion = (Result<Void, Error>) -> Void
#endif

public typealias MediaType = PHAssetMediaType
public typealias MediaSubtype = PHAssetMediaSubtype

public typealias ResultDataCompletion = (Result<Data, Swift.Error>) -> Void
public typealias ResultGenericCompletion<T> = (Result<T, Swift.Error>) -> Void
public typealias ResultLivePhotoCompletion = (Result<LivePhoto, Error>) -> Void
public typealias RequestLivePhotoResultHandler = (PHLivePhoto?, [AnyHashable : Any]) -> Void
public typealias ResultPHAssetCompletion = (Result<PHAsset, Swift.Error>) -> Void
public typealias ResultPhotoCompletion = (Result<Photo, Swift.Error>) -> Void
public typealias ResultURLCompletion = (Result<URL, Swift.Error>) -> Void
public typealias ResultVideoCompletion = (Result<Video, Swift.Error>) -> Void
public typealias ResultVoidCompletion = (Result<Void, Swift.Error>) -> Void
