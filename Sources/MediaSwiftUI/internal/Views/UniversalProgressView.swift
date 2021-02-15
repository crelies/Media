//
//  UniversalProgressView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15.02.21.
//

import SwiftUI

struct UniversalProgressView: View {
    var body: some View {
        if #available(iOS 14, macOS 11, tvOS 14, *) {
            ProgressView()
        } else {
            ActivityIndicatorView()
        }
    }
}

#if DEBUG
struct UniversalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        UniversalProgressView()
    }
}
#endif
