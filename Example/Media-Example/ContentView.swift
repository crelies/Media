//
//  ContentView.swift
//  Media-Example
//
//  Created by Christian Elies on 22.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaSwiftUI
import SwiftUI

struct ContentView: View {
    #if !os(tvOS)
    @ObservedObject var cameraViewModel: PhotoCameraViewModel
    #endif

    var body: some View {
        #if !os(tvOS)
        RootScreen(cameraViewModel: cameraViewModel)
        #else
        RootScreen()
        #endif
    }
}

#if !os(tvOS) && !os(macOS)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cameraViewModel: rootCameraViewModel)
    }
}
#endif
