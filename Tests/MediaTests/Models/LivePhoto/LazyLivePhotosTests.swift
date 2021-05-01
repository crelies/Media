@testable import MediaCore
import XCTest

final class LazyLivePhotosTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        Media.photoLibrary = MockPhotoLibrary.self
        PHChanger.photoLibrary = MockPhotoLibrary()
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
    }

    func testAllEmpty() {
        let livePhotos = LazyLivePhotos.all
        XCTAssertEqual(livePhotos?.count, 0)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let livePhotos = LazyLivePhotos.all
        XCTAssertEqual(livePhotos?.count, 1)
    }
}
