//
//  AlbumTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import Photos
import XCTest

final class AlbumTypeTests: XCTestCase {
    func testAssetCollectionTypeForUserType() {
        let albumType: AlbumType = .user
        XCTAssertEqual(albumType.assetCollectionType, .album)
    }

    func testAssetCollectionTypeForCloudType() {
        let albumType: AlbumType = .cloud
        XCTAssertEqual(albumType.assetCollectionType, .album)
    }

    func testAssetCollectionTypeForSmartType() {
        let albumType: AlbumType = .smart
        XCTAssertEqual(albumType.assetCollectionType, .smartAlbum)
    }

    func testSubtypesForUserType() {
        let albumType: AlbumType = .user
        let expectedSubtypes: [PHAssetCollectionSubtype] = [.albumRegular,
                                                            .albumSyncedEvent,
                                                            .albumSyncedFaces,
                                                            .albumSyncedAlbum,
                                                            .albumImported]
        XCTAssertEqual(albumType.subtypes, expectedSubtypes)
    }

    func testSubtypesForCloudType() {
        let albumType: AlbumType = .cloud
        let expectedSubtypes: [PHAssetCollectionSubtype] = [.albumMyPhotoStream, .albumCloudShared]
        XCTAssertEqual(albumType.subtypes, expectedSubtypes)
    }

    @available(iOS 13, *)
    @available(macOS 10.15, *)
    @available(tvOS 11, *)
    func testSubtypesForSmartType() {
        let albumType: AlbumType = .smart
        let expectedSubtypes: [PHAssetCollectionSubtype] = [.smartAlbumScreenshots,
                                                            .smartAlbumSelfPortraits,
                                                            .smartAlbumDepthEffect,
                                                            .smartAlbumLivePhotos,
                                                            .smartAlbumAnimated,
                                                            .smartAlbumLongExposures,
                                                            .smartAlbumGeneric,
                                                            .smartAlbumPanoramas,
                                                            .smartAlbumVideos,
                                                            .smartAlbumFavorites,
                                                            .smartAlbumTimelapses,
                                                            .smartAlbumAllHidden,
                                                            .smartAlbumRecentlyAdded,
                                                            .smartAlbumBursts,
                                                            .smartAlbumSlomoVideos,
                                                            .smartAlbumUserLibrary]
        XCTAssertEqual(albumType.subtypes, expectedSubtypes)
    }
}
