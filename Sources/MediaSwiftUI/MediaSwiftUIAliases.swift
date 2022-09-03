//
//  MediaSwiftUIAliases.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03.05.21.
//

import MediaCore
import Photos

public typealias ResultPhotosCompletion = (Result<[BrowserResult<Photo, UniversalImage>], Swift.Error>) -> Void
public typealias ResultVideosCompletion = (Result<[BrowserResult<Video, URL>], Swift.Error>) -> Void
