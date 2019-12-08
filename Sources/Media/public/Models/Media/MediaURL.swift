//
//  MediaURL.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

import Foundation

/// Generic URL type for different types of media
/// like `Photo` or `Video`
///
public struct MediaURL<T: MediaProtocol> {
    let value: URL
    let fileType: T.MediaFileType

    /// Initializes with the given URL
    /// Throws a `MediaURLError` if the path extension of the URL doesn't match the specific file type
    ///
    /// - Parameter url: the URL of the media
    ///
    public init(url: URL) throws {
        let supportedPathExtensions = Set(T.MediaFileType.allCases.map { $0.pathExtensions }.flatMap {$0 })

        switch url.pathExtension {
        case \.isEmpty:
            throw MediaURLError.missingPathExtension
        case .unsupportedPathExtension(supportedPathExtensions: supportedPathExtensions):
            throw MediaURLError.unsupportedPathExtension
        default:
            guard let fileType = T.MediaFileType(rawValue: url.pathExtension) else {
                throw MediaURLError.couldNotCreateFileType
            }
            self.value = url
            self.fileType = fileType
        }
    }
}
