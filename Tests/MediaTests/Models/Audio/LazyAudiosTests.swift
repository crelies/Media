@testable import MediaCore
import XCTest

final class LazyAudiosTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        Media.photoLibrary = MockPhotoLibrary.self
        PHChanger.photoLibrary = MockPhotoLibrary()
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
    }

    func testAllEmpty() {
        let audios = LazyAudios.all
        XCTAssertEqual(audios?.count, 0)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let audios = LazyAudios.all
        XCTAssertEqual(audios?.count, 1)
    }
}
