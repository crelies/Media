//
//  Item.swift
//  Media-Example
//
//  Created by Christian Elies on 20.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

enum Item: Identifiable {
    var id: String {
        switch self {
        case let .albums(albums):
            return albums.id
        case let .album(albums, index):
            return "\(albums.id)\(index)"
        case let .livePhotos(album):
            return album?.id ?? UUID().uuidString
        case let.livePhoto(livePhotos, index):
            return "\(livePhotos.id)\(index)"
        case let .photos(album):
            return album?.id ?? UUID().uuidString
        case let .photo(photos, index):
            return "\(photos.id)\(index)"
        case let .videos(album):
            return album?.id ?? UUID().uuidString
        case let .video(videos, index):
            return "\(videos.id)\(index)"
        }
    }

    case albums(albums: LazyAlbums)
    case album(albums: LazyAlbums, index: Int)

    case livePhotos(album: LazyAlbum?)
    case livePhoto(livePhotos: LazyLivePhotos, index: Int)

    case photos(album: LazyAlbum?)
    case photo(photos: Media.LazyPhotos, index: Int)

    case videos(album: LazyAlbum?)
    case video(videos: LazyVideos, index: Int)
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        switch (lhs, rhs) {
        case (.albums(let leftAlbums), albums(let rightAlbums)):
            return leftAlbums == rightAlbums
        case (.album(let leftAlbums, let leftIndex), album(let rightAlbums, let rightIndex)):
            return leftAlbums == rightAlbums && leftIndex == rightIndex
        case (.livePhotos(let leftAlbum), livePhotos(let rightAlbum)):
            return leftAlbum == rightAlbum
        case (.livePhoto(let leftLivePhotos, let leftIndex), livePhoto(let rightLivePhotos, let rightIndex)):
            return leftLivePhotos == rightLivePhotos && leftIndex == rightIndex
        case (.photos(let leftAlbum), photos(let rightAlbum)):
            return leftAlbum == rightAlbum
        case (.photo(let leftPhotos, let leftIndex), photo(let rightPhotos, let rightIndex)):
            return leftPhotos == rightPhotos && leftIndex == rightIndex
        case (.videos(let leftAlbum), videos(let rightAlbum)):
            return leftAlbum == rightAlbum
        case (.video(let leftVideos, let leftIndex), video(let rightVideos, let rightIndex)):
            return leftVideos == rightVideos && leftIndex == rightIndex
        default:
            return false
        }
    }
}

extension Item: Node {
    var children: [Item]? {
        switch self {
        case let .albums(albums):
            return (0..<albums.count).map { Item.album(albums: albums, index: $0) }
        case let .album(albums, index):
            return [
                .livePhotos(album: albums[index]),
                .photos(album: albums[index]),
                .videos(album: albums[index])
            ]
        case let .livePhotos(album):
            if let album = album, let livePhotos = album.livePhotos, livePhotos.count > 0 {
                return (0..<livePhotos.count).map { Item.livePhoto(livePhotos: livePhotos, index: $0) }
            } else {
                return nil
            }
        case let .photos(album):
            if let album = album, let photos = album.photos, photos.count > 0 {
                return (0..<photos.count).map { Item.photo(photos: photos, index: $0) }
            } else {
                return nil
            }
        case let .videos(album):
            if let album = album, let videos = album.videos, videos.count > 0 {
                return (0..<videos.count).map { Item.video(videos: videos, index: $0) }
            } else {
                return nil
            }
        default:
            return nil
        }
    }

    @ViewBuilder var view: some View {
        switch self {
        case let .albums(albums):
            Text("Albums") + Text(" (\(albums.count))").font(.footnote)
        case let .album(albums, index):
            LazyView(data: { albums[index] }) { album in
                Text("Album at index \(index)")
            }
        case let .livePhotos(album):
            if let album = album, let livePhotos = album.livePhotos, livePhotos.count > 0 {
                Text("Live Photos") + Text(" (\(livePhotos.count))").font(.footnote)
            }
        case let .livePhoto(livePhotos, index):
            LazyView(data: { livePhotos[index] }) { livePhoto in
                if let livePhoto = livePhotos[index] {
                    NavigationLink(destination: LivePhotoView(livePhoto: livePhoto)) {
                        Text(livePhoto.identifier?.localIdentifier ?? "")
                    }
                }
            }
        case let .photos(album):
            if let album = album, let photos = album.photos, photos.count > 0 {
                Text("Photos") + Text(" (\(photos.count))").font(.footnote)
            }
        case let .photo(photos, index):
            LazyView(data: { photos[index] }) { photo in
                if let photo = photos[index] {
                    NavigationLink(destination: PhotoView(photo: photo)) {
                        Text(photo.identifier?.localIdentifier ?? "")
                    }
                }
            }
        case let .videos(album):
            if let album = album, let videos = album.videos, videos.count > 0 {
                Text("Videos") + Text(" (\(videos.count))").font(.footnote)
            }
        case let .video(videos, index):
            LazyView(data: { videos[index] }) { video in
                if let video = videos[index] {
                    NavigationLink(destination: VideoView(video: video)) {
                        Text(video.identifier?.localIdentifier ?? "")
                    }
                }
            }
        }
    }
}
