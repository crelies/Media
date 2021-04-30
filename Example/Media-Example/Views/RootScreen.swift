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
    @State private var isLimitedLibraryPickerPresented = false

    @FetchAssets(sort: [Media.Sort(key: .creationDate, ascending: true)])
    private var videos: [Video]

    @FetchAlbums(ofType: .smart)
    private var albums: [Album]

    var body: some View {
        NavigationView {
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
                List {
                    Section {
                        Button(action: {
                            Media.requestCameraPermission { result in
                                debugPrint(result)
                            }
                        }) {
                            Text("Trigger camera permission request")
                        }

                        Button(action: {
                            if Media.currentPermission == .limited {
                                isLimitedLibraryPickerPresented = true
                            } else {
                                requestPermission()
                            }
                        }) {
                            Text("Trigger photo library permission request")
                        }
                        .fullScreenCover(isPresented: $isLimitedLibraryPickerPresented, onDismiss: {
                            isLimitedLibraryPickerPresented = false
                        }) {
                            let result = Result {
                                try Media.browser { _ in }
                            }
                            switch result {
                            case let .success(view):
                                view
                            case let .failure(error):
                                Text(error.localizedDescription)
                            }
                        }
                    }

                    Section {
                        NavigationLink(destination: VideosView(videos: videos)) {
                            Text("@FetchAssets videos")
                        }

                        NavigationLink(destination: AlbumsView(albums: albums)) {
                            Text("@FetchAlbums smart")
                        }
                    }

                    Section {
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

                        NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                            Text("User albums (\(userAlbums.count))")
                        }

                        if let lazyCloudAlbums = lazyCloudAlbums {
                            NavigationLink(destination: LazyAlbumsView(albums: lazyCloudAlbums)) {
                                Text("Lazy Cloud albums (\(lazyCloudAlbums.count))")
                            }
                        }

                        NavigationLink(destination: AlbumsView(albums: cloudAlbums)) {
                            Text("Cloud albums (\(cloudAlbums.count))")
                        }

                        if let smartAlbums = lazySmartAlbums {
                            NavigationLink(destination: LazyAlbumsView(albums: smartAlbums)) {
                                Text("Lazy Smart albums (\(smartAlbums.count))")
                            }
                        }

                        NavigationLink(destination: AlbumsView(albums: smartAlbums)) {
                            Text("Smart albums (\(smartAlbums.count))")
                        }
                    }

                    if let audios = LazyAudios.all {
                        Section {
                            NavigationLink(destination: LazyAudiosView(audios: audios)) {
                                Text("LazyAudios.all (\(audios.count))")
                            }
                        }
                    }

                    PhotosSection()

                    VideosSection()

                    CameraSection()

                    BrowserSection()
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Examples")
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
    func requestPermission() {
        Media.requestPermission { result in
            switch result {
            case .success:
                permissionState = .granted
                fetchAlbums()
            case .failure(let error):
                permissionState = .failed(error as NSError)
            }
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

#if DEBUG
struct AlbumsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
#endif
