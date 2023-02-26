//
//  RootScreen.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import MediaSwiftUI
import SwiftUI

struct RootScreen: View {
    private enum PermissionState: Equatable {
        case granted
        case loading
        case failed(_ error: NSError)
    }

    @State private var lazyUserAlbums: LazyAlbums?
    @State private var userAlbums: [Album] = []
    @State private var lazyCloudAlbums: LazyAlbums?
    @State private var cloudAlbums: [Album] = []
    @State private var lazySmartAlbums: LazyAlbums?
    @State private var smartAlbums: [Album] = []

    @State private var permissionState: PermissionState = .loading

    @FetchAssets(sort: [Media.Sort(key: .creationDate, ascending: true)])
    private var videos: [Video]

    @FetchAlbums(ofType: .smart)
    private var albums: [Album]

    #if !os(tvOS)
    @ObservedObject var cameraViewModel: PhotoCameraViewModel
    #endif

    #if os(macOS)
    @ObservedObject var videoCameraViewModel: VideoCameraViewModel
    #endif

    var body: some View {
        NavigationStack {
            switch permissionState {
            case .loading:
                ProgressView()
                    .onAppear {
                        if !Media.isAccessAllowed {
                            requestPermission()
                        } else {
                            permissionState = .granted
                            fetchAlbums()
                        }
                    }
            case .granted:
                grantedList()
            case let .failed(error):
                VStack(spacing: 20) {
                    Text(error.localizedDescription)

                    Button(action: requestPermission) {
                        Text("Trigger photo library permission request")
                    }
                }
            }
        }
    }
}

private extension RootScreen {
    func grantedList() -> some View {
        List {
            #if !os(tvOS)
            PermissionsSection(requestedPermission: handleRequestPermissionResult)
            #endif

            Section(header: Text("Property wrapper")) {
                NavigationLink(destination: VideosView(videos: videos)) {
                    Text("@FetchAssets videos")
                }

                NavigationLink(destination: AlbumsView(albums: albums)) {
                    Text("@FetchAlbums smart")
                }
            }

            albumsSection()


            Section(header: Label("Audios", systemImage: "waveform")) {
                let audios = Audios.all
                NavigationLink(destination: AudiosView(audios: audios)) {
                    Text("Audios.all (\(audios.count))")
                }

                if let lazyAudios = LazyAudios.all {
                    NavigationLink(destination: LazyAudiosView(audios: lazyAudios)) {
                        Text("LazyAudios.all (\(lazyAudios.count))")
                    }
                }
            }

            PhotosSection()

            VideosSection()

            #if !targetEnvironment(macCatalyst) && os(iOS)
            CameraSection(cameraViewModel: cameraViewModel)
            #elseif os(macOS)
            CameraSection(cameraViewModel: cameraViewModel, videoCameraViewModel: videoCameraViewModel)
            #elseif targetEnvironment(macCatalyst) 
            CameraSection()
            #endif

            #if !os(tvOS)
            BrowserSection()
            #endif
        }
        #if !os(tvOS) && !os(macOS)
        .listStyle(InsetGroupedListStyle())
        #endif
        #if !os(macOS)
        .navigationBarTitle("Examples")
        #endif
    }

    func albumsSection() -> some View {
        Section(header: Label("Albums", systemImage: "person.2.square.stack")) {
            NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                Text("User albums (\(userAlbums.count))")
            }

            NavigationLink(destination: AlbumsView(albums: cloudAlbums)) {
                Text("Cloud albums (\(cloudAlbums.count))")
            }

            NavigationLink(destination: AlbumsView(albums: smartAlbums)) {
                Text("Smart albums (\(smartAlbums.count))")
            }

            if let userAlbums = lazyUserAlbums {
                let item = Item.albums(albums: userAlbums)
                NavigationLink(destination: ScrollView {
                    LazyTree(node: item, children: \.children)
                }) {
                    Text("Lazy Tree (with user albums)")
                }

                NavigationLink(destination: LazyAlbumsView(albums: userAlbums)) {
                    Text("Lazy User albums (\(userAlbums.count))")
                }
            }

            if let lazyCloudAlbums = lazyCloudAlbums {
                NavigationLink(destination: LazyAlbumsView(albums: lazyCloudAlbums)) {
                    Text("Lazy Cloud albums (\(lazyCloudAlbums.count))")
                }
            }

            if let smartAlbums = lazySmartAlbums {
                NavigationLink(destination: LazyAlbumsView(albums: smartAlbums)) {
                    Text("Lazy Smart albums (\(smartAlbums.count))")
                }
            }
        }
    }

    func requestPermission() {
        Media.requestPermission(handleRequestPermissionResult)
    }

    func handleRequestPermissionResult(_ result: Result<Void, PermissionError>) {
        switch result {
        case .success:
            permissionState = .granted
            fetchAlbums()
        case .failure(let error):
            permissionState = .failed(error as NSError)
        }
    }

    func fetchAlbums() {
        lazyUserAlbums = LazyAlbums.user
        userAlbums = Albums.user
        lazyCloudAlbums = LazyAlbums.cloud
        cloudAlbums = Albums.cloud
        lazySmartAlbums = LazyAlbums.smart
        smartAlbums = Albums.smart
    }
}

#if !os(tvOS) && !os(macOS)
struct AlbumsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen(cameraViewModel: rootCameraViewModel)
    }
}
#endif
