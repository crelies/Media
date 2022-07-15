//
//  UniversalProgressView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15.02.21.
//

import SwiftUI

@available(macOS 11, *)
struct UniversalProgressView: View {
    var body: some View {
        if #available(iOS 14, tvOS 14, *) {
            ProgressView()
        } else {
            #if canImport(UIKit)
            ActivityIndicatorView()
            #endif
        }
    }
}

@available(macOS 11, *)
struct UniversalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        UniversalProgressView()
    }
}
