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
    @ObservedObject var cameraViewModel: LivePhotoCameraViewModel

    var body: some View {
        RootScreen(cameraViewModel: cameraViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cameraViewModel: rootCameraViewModel)
    }
}
