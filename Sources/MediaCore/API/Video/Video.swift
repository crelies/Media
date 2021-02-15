//
//  Video.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Wrapper type around `PHAsset`s of type
/// `video`
///
public struct Video: MediaProtocol {
    public typealias ProgressHandler = (Video.ExportProgress) -> Void

    static var videoManager: VideoManager = PHImageManager.default()

    private var phAsset: PHAsset? { phAssetWrapper.value }

    public typealias MediaSubtype = Video.Subtype
    public typealias MediaFileType = Video.FileType

    /// Box type internally used to store
    /// a reference to the underlying `PHAsset` instance
    ///
    public let phAssetWrapper: PHAssetWrapper

    /// Represents the `PHAssetMediaType` of the `Video` type
    /// Used for the implementation of some generic property
    /// wrappers
    ///
    public static let type: MediaType = .video

    /// Locally available metadata of the `Video`
    public var metadata: Metadata? {
        guard let phAsset = phAsset else { return nil }
        return Metadata(
            type: phAsset.mediaType,
            subtypes: phAsset.mediaSubtypes,
            sourceType: phAsset.sourceType,
            creationDate: phAsset.creationDate,
            modificationDate: phAsset.modificationDate,
            location: phAsset.location,
            isFavorite: phAsset.isFavorite,
            isHidden: phAsset.isHidden,
            pixelWidth: phAsset.pixelWidth,
            pixelHeight: phAsset.pixelHeight,
            duration: phAsset.duration)
    }

    /// Initializes a `Video` using the given `PHAsset`
    ///
    /// - Parameter phAsset: a `PHAsset` of type `video`
    ///
    public init(phAsset: PHAsset) {
        phAssetWrapper = PHAssetWrapper(value: phAsset)
    }
}

public extension Video {
    /// Computes the subtypes of the receiver
    /// Similar to tags, like `highFrameRate` or `timelapse`
    ///
    var subtypes: [Video.Subtype] {
        guard let phAsset = phAsset else { return []}

        var types: [Video.Subtype] = []

        switch phAsset.mediaSubtypes {
        case [.videoHighFrameRate, .videoStreamed, .videoTimelapse]:
            types.append(contentsOf: [.highFrameRate, .streamed, .timelapse])

        case [.videoHighFrameRate, .videoStreamed]:
            types.append(contentsOf: [.highFrameRate, .streamed])
        case [.videoStreamed, .videoTimelapse]:
            types.append(contentsOf: [.streamed, .timelapse])

        case [.videoHighFrameRate]:
            types.append(.highFrameRate)
        case [.videoStreamed]:
            types.append(.streamed)
        case [.videoTimelapse]:
            types.append(.timelapse)
        default: ()
        }

        return types
    }
}

public extension Video {
    typealias ResultVideoPropertiesCompletion = (Result<Properties, Swift.Error>) -> Void

    /// Get all metadata of the `Video` (locally + remotely available)
    /// Keep in mind that this method might download a copy
    /// of the `Video` from the cloud to get the information
    ///
    /// - Parameter completion: `Result` containing a `Properties` object on `success` or an error on `failure`
    ///
    func properties(_ completion: @escaping ResultVideoPropertiesCompletion) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        Self.videoManager.requestAVAsset(forVideo: phAsset, options: options) { avAsset, _, info in
            PHImageManager.handleResult(result: (avAsset, info)) { result in
                switch result {
                case .success(let avAsset):
                    let properties = Properties(metadata: avAsset.metadata)
                    completion(.success(properties))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

public extension Video {
    typealias ResultAVPlayerItemCompletion = (Result<AVPlayerItem, Swift.Error>) -> Void
    typealias ResultAVAssetCompletion = (Result<AVAsset, Swift.Error>) -> Void

    /// Generates a preview image for the receiving video.
    /// The process runs on a background thread.
    ///
    /// - Parameter requestedTime: The time at which the image of the asset is to be created, defaults to `.init(seconds: 1, preferredTimescale: 60)`.
    /// - Parameter completion: a closure which gets an `UniversalImage` on `success` and `Error` on `failure`.
    func previewImage(at requestedTime: CMTime = .init(seconds: 1, preferredTimescale: 60), _ completion: @escaping (Result<UniversalImage, Swift.Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            avAsset { avAssetResult in
                switch avAssetResult {
                case let .success(asset):
                    let generator = AVAssetImageGenerator(asset: asset)
                    generator.appliesPreferredTrackTransform = true

                    let copyCGImageResult: Result<UniversalImage, Swift.Error> = Result {
                        let cgImage = try generator.copyCGImage(at: requestedTime, actualTime: nil)
                        return UniversalImage(cgImage: cgImage)
                    }

                    DispatchQueue.main.async {
                        completion(copyCGImageResult)
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    /// Creates a `AVPlayerItem` representation of the receiver
    ///
    /// - Parameter completion: a closure which gets an `AVPlayerItem` on `success` and `Error` on `failure`
    ///
    func playerItem(deliveryMode: PHVideoRequestOptionsDeliveryMode = .automatic, _ completion: @escaping ResultAVPlayerItemCompletion) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = deliveryMode

        Self.videoManager.requestPlayerItem(forVideo: phAsset, options: options) { playerItem, info in
            PHImageManager.handleResult(result: (playerItem, info), completion)
        }
    }

    /// Creates a `AVAsset` representation of the receiver
    ///
    /// - Parameter completion: a closure which gets an `AVAsset` on `success` and `Error` on `failure`
    ///
    func avAsset(deliveryMode: PHVideoRequestOptionsDeliveryMode = .automatic, _ completion: @escaping ResultAVAssetCompletion) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = deliveryMode

        Self.videoManager.requestAVAsset(forVideo: phAsset, options: options) { asset, _, info in
            PHImageManager.handleResult(result: (asset, info), completion)
        }
    }

    /// Exports the receiver using the given options
    /// Notifies about the `progress` through the given closure
    ///
    /// - Parameters:
    ///   - exportOptions: options specifying destination, file type and quality
    ///   - progress: a closure which gets the current `Video.ExportProgress`
    ///   - completion: a closure which gets a `Void` on `success` and `Error` on `failure`
    ///
    func export(_ exportOptions: Video.ExportOptions, progress: @escaping ProgressHandler, _ completion: @escaping ResultVoidCompletion) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        guard let exportPreset = exportOptions.quality.avAssetExportPreset else {
            completion(.failure(Error.unsupportedExportPreset))
            return
        }

        let requestOptions = PHVideoRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = exportOptions.deliveryMode

        Self.videoManager.requestExportSession(forVideo: phAsset,
                                               options: requestOptions,
                                               exportPreset: exportPreset)
        { exportSession, info in
            if let error = info?[PHImageErrorKey] as? Swift.Error {
                completion(.failure(error))
            } else if let exportSession = exportSession {
                exportSession.determineCompatibleFileTypes { compatibleFileTypes in
                    guard compatibleFileTypes.contains(exportOptions.outputURL.fileType.avFileType) else {
                        completion(.failure(Error.unsupportedFileType))
                        return
                    }

                    exportSession.outputURL = exportOptions.outputURL.value
                    exportSession.outputFileType = exportOptions.outputURL.fileType.avFileType

                    let timer = self.createTimer(for: exportSession, progress: progress)
                    RunLoop.main.add(timer, forMode: .common)

                    exportSession.exportAsynchronously {
                        switch exportSession.status {
                        case .completed:
                            timer.invalidate()
                            completion(.success(()))
                        case .failed:
                            timer.invalidate()
                            completion(.failure(exportSession.error ?? Media.Error.unknown))
                        case .cancelled:
                            timer.invalidate()
                            completion(.failure(exportSession.error ?? Media.Error.cancelled))
                        default: ()
                        }
                    }
                }
            } else {
                completion(.failure(Media.Error.unknown))
            }
        }
    }
}

public extension Video {
    /// Fetches the `Video` with the given identifier if it exists
    ///
    /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234")])
    /// private var video: Video?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Media.Identifier<Self>) throws -> Video? {
        let options = PHFetchOptions()

        let localIdentifierFilter: Media.Filter<Video.Subtype> = .localIdentifier(identifier.localIdentifier)
        let mediaTypePredicate = NSPredicate(format: "mediaType = %d", MediaType.video.rawValue)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate, localIdentifierFilter.predicate])
        options.predicate = predicate

        let video = try PHAssetFetcher.fetchAsset(options: options) { $0.localIdentifier == identifier.localIdentifier && $0.mediaType == .video } as Video?
        return video
    }
}

public extension Video {
    /// Saves the video media at the given URL if
    /// - the access to the photo library is allowed
    /// - the path extension of the URL matches a `Video.FileType` path extension
    ///
    /// - Parameters:
    ///   - url: URL to the media
    ///   - completion: a closure which gets `Video` on `success` and `Error` on `failure`
    ///
    static func save(_ mediaURL: Media.URL<Self>, _ completion: @escaping ResultVideoCompletion) {
        PHAssetChanger.createRequest({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: mediaURL.value) }, completion)
    }

    /// Updates the `favorite` state of the receiver if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - favorite: a boolean indicating the new `favorite` state
    ///   - completion: a closure which gets `Void` on `success` and `Error` on `failure`
    ///
    func favorite(_ favorite: Bool, _ completion: @escaping ResultVoidCompletion) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }
        
        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite) { result in
            do {
                self.phAssetWrapper.value = try result.get()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension Video {
    private func handleProgressTimerFired(exportSession: AVAssetExportSession,
                                          timer: Timer,
                                          progress: @escaping ProgressHandler) {
        guard exportSession.progress < 1 else {
            let exportProgress: ExportProgress = .completed
            progress(exportProgress)
            timer.invalidate()
            return
        }
        let exportProgress: ExportProgress = .pending(value: exportSession.progress)
        progress(exportProgress)
    }

    private func createTimer(for exportSession: AVAssetExportSession,
                             progress: @escaping ProgressHandler) -> Timer {
        var timer: Timer

        if #available(iOS 10, macOS 10.13, tvOS 10, *) {
            timer = Timer(timeInterval: 1, repeats: true) { timer in
                self.handleProgressTimerFired(exportSession: exportSession,
                                              timer: timer,
                                              progress: progress)
            }
        } else {
            let timerWrapper = TimerWrapper(timeInterval: 1, repeats: true) { timer in
                self.handleProgressTimerFired(exportSession: exportSession,
                                              timer: timer,
                                              progress: progress)
            }
            timer = timerWrapper.timer
        }

        return timer
    }
}
