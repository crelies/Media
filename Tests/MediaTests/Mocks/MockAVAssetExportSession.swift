//
//  MockAVAssetExportSession.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

#if !os(tvOS)
import AVFoundation
@testable import MediaCore

@available(iOS 13, *)
final class MockAVAssetExportSession: AVAssetExportSession {
    private let id: String
    private var exportAsynchronouslyHandler: (() -> Void)?

    static var avAsset: AVAsset = AVMovie()
    static var presetName: String = AVAssetExportPresetHighestQuality

    var statusToReturn: AVAssetExportSession.Status = .unknown
    var progressToReturn: Float = 0
    var compatibleFileTypesToReturn: [AVFileType] = []
    var exportAsynchronouslyStatus: AVAssetExportSession.Status = .unknown {
        didSet {
            if statusToReturn != .unknown {
                statusToReturn = exportAsynchronouslyStatus
            }
            exportAsynchronouslyHandler?()
        }
    }

    override var status: AVAssetExportSession.Status { statusToReturn }
    override var progress: Float { progressToReturn }

    init?(id: String = UUID().uuidString) {
        self.id = id
        super.init(asset: Self.avAsset, presetName: Self.presetName)
    }

    override func determineCompatibleFileTypes(completionHandler handler: @escaping ([AVFileType]) -> Void) {
        handler(compatibleFileTypesToReturn)
    }

    override func exportAsynchronously(completionHandler handler: @escaping () -> Void) {
        statusToReturn = exportAsynchronouslyStatus
        exportAsynchronouslyHandler = handler
        handler()
    }
}
#endif
