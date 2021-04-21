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

    @State private var userAlbums: LazyAlbums?
    @State private var cloudAlbums: LazyAlbums?
    @State private var smartAlbums: LazyAlbums?

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

                            userAlbums = LazyAlbums.user
                            cloudAlbums = LazyAlbums.cloud
                            smartAlbums = LazyAlbums.smart
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
                        // TODO:
//                        NavigationLink(destination: VideosView(videos: videos)) {
//                            Text("@FetchAssets videos")
//                        }

                        // TODO:
//                        NavigationLink(destination: AlbumsView(albums: albums)) {
//                            Text("@FetchAlbums smart")
//                        }
                    }

                    Section {
                        if let userAlbums = userAlbums {
                            NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                                Text("User albums (\(userAlbums.count))")
                            }

                            let item = Item.albums(albums: userAlbums)
                            NavigationLink(destination: ScrollView {
                                LazyTree(node: item, children: \.children)
                            }) {
                                Text("Lazy Tree")
                            }
                        }

                        if let cloudAlbums = cloudAlbums {
                            NavigationLink(destination: AlbumsView(albums: cloudAlbums)) {
                                Text("Cloud albums (\(cloudAlbums.count))")
                            }
                        }

                        if let smartAlbums = smartAlbums {
                            NavigationLink(destination: AlbumsView(albums: smartAlbums)) {
                                Text("Smart albums (\(smartAlbums.count))")
                            }
                        }
                    }

                    if let audios = LazyAudios.all {
                        Section {
                            NavigationLink(destination: AudiosView(audios: audios)) {
                                Text("Audios.all (\(audios.count))")
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

                userAlbums = LazyAlbums.user
                cloudAlbums = LazyAlbums.cloud
                smartAlbums = LazyAlbums.smart
            case .failure(let error):
                permissionState = .failed(error as NSError)
            }
        }
    }
}

#if DEBUG
struct AlbumsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
#endif
