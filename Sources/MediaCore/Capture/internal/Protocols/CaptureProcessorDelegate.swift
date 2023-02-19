//
//  CaptureProcessorDelegate.swift
//  MediaCore
//
//  Created by Christian Elies on 17.01.20.
//

import Foundation

@available(iOS 10, *)
@available(tvOS, unavailable)
protocol CaptureProcessorDelegate: AnyObject {
    func didCapturePhoto(data: Data)
    #if !os(macOS)
    func didCaptureLivePhoto(data: CapturedPhotoData)
    #endif
}
