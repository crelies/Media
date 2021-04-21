//
//  Equatable+Hashable.swift
//  Media-Example
//
//  Created by Christian Elies on 20.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore

extension LazyAlbums: Equatable {
    public static func == (lhs: LazyAlbums, rhs: LazyAlbums) -> Bool {
        lhs.count == rhs.count
    }
}

extension LazyAlbums: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
}

extension LazyAlbum: Equatable {
    public static func == (lhs: LazyAlbum, rhs: LazyAlbum) -> Bool {
        lhs.id == rhs.id
    }
}

extension LazyAlbum: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Album: Equatable {
    public static func == (lhs: Album, rhs: Album) -> Bool {
        lhs.id == rhs.id
    }
}

extension Album: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Media.LazyPhotos: Equatable {
    public static func == (lhs: Media.LazyPhotos, rhs: Media.LazyPhotos) -> Bool {
        lhs.count == rhs.count
    }
}

extension Media.LazyPhotos: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
}

extension LazyPhoto: Equatable {
    public static func == (lhs: LazyPhoto, rhs: LazyPhoto) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension LazyPhoto: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Photo: Equatable {
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}

extension Photo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LazyVideos: Equatable {
    public static func == (lhs: LazyVideos, rhs: LazyVideos) -> Bool {
        lhs.count == rhs.count
    }
}

extension LazyVideos: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
}

extension LazyVideo: Equatable {
    public static func == (lhs: LazyVideo, rhs: LazyVideo) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension LazyVideo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Video: Equatable {
    public static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id
    }
}

extension Video: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LazyLivePhotos: Equatable {
    public static func == (lhs: LazyLivePhotos, rhs: LazyLivePhotos) -> Bool {
        lhs.count == rhs.count
    }
}

extension LazyLivePhotos: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
}

extension LazyLivePhoto: Equatable {
    public static func == (lhs: LazyLivePhoto, rhs: LazyLivePhoto) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension LazyLivePhoto: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension LivePhoto: Equatable {
    public static func == (lhs: LivePhoto, rhs: LivePhoto) -> Bool {
        lhs.id == rhs.id
    }
}

extension LivePhoto: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LazyAudios: Equatable {
    public static func == (lhs: LazyAudios, rhs: LazyAudios) -> Bool {
        lhs.count == rhs.count
    }
}

extension LazyAudios: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
}

extension LazyAudio: Equatable {
    public static func == (lhs: LazyAudio, rhs: LazyAudio) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension LazyAudio: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Audio: Equatable {
    public static func == (lhs: Audio, rhs: Audio) -> Bool {
        lhs.id == rhs.id
    }
}

extension Audio: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
