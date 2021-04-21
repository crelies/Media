//
//  LazyView.swift
//  Media-Example
//
//  Created by Christian Elies on 25.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import SwiftUI

struct LazyView<Data: Hashable, Content: View>: View {
    @State private var viewState: ViewState<Data> = .loading

    let data: () -> Data
    let content: (Data) -> Content

    var body: some View {
        switch viewState {
        case .loading:
            ProgressView()
                .onAppear(perform: loadData)
        case let .loaded(value):
            content(value)
        case let .failed(error):
            Text(error.localizedDescription)
        }
    }

    init(data: @escaping () -> Data, @ViewBuilder content: @escaping (Data) -> Content) {
        self.data = data
        self.content = content
    }

    private func loadData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = data()
            DispatchQueue.main.async {
                viewState = .loaded(value: result)
            }
        }
    }
}
