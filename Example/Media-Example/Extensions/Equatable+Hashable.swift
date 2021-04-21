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
