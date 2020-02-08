//
//  Media+URL.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

import Foundation

extension Media {
    /// Generic URL type for different types of media
    /// like `Photo` or `Video`
    ///
    public struct URL<T: MediaProtocol> {
        let value: Foundation.URL
        let fileType: T.MediaFileType

        /// Initializes with the given URL
        /// Throws a `MediaURLError` if the path extension of the URL doesn't match the specific file type
        ///
        /// - Parameter url: the URL of the media
        ///
        public init(url: Foundation.URL) throws {
            let supportedPathExtensions = Set(T.MediaFileType.allCases.map { $0.pathExtensions }.flatMap {$0 })

            switch url.pathExtension {
            case \.isEmpty:
                throw Media.URL<T>.Error.missingPathExtension
            case .unsupportedPathExtension(supportedPathExtensions: supportedPathExtensions):
                throw Media.URL<T>.Error.unsupportedPathExtension
            default:
                guard let fileType = T.MediaFileType(rawValue: url.pathExtension) else {
                    throw Media.URL<T>.Error.couldNotCreateFileType
                }
                self.value = url
                self.fileType = fileType
            }
        }
    }
}

extension Media.URL: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value && lhs.fileType.rawValue == rhs.fileType.rawValue
    }
}
