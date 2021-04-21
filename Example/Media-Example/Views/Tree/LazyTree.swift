//
//  LazyTree.swift
//  Media-Example
//
//  Created by Christian Elies on 25.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import SwiftUI

private struct ExpandableView<Title: View, Content: View>: View {
    @State private var isExpanded = false

    var title: () -> Title
    var content: () -> Content

    var body: some View {
        Button(action: {
            isExpanded = !isExpanded
        }) {
            HStack {
                title()
                Spacer()
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)

        if isExpanded {
            LazyVStack(alignment: .leading, content: content)
        }
    }

    init(@ViewBuilder title: @escaping () -> Title, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
}

struct LazyTree<N: Node>: View {
    let node: N
    let children: KeyPath<N, [N]?>

    var body: some View {
        if let childs = node[keyPath: \.children], !childs.isEmpty {
            ExpandableView(title: {
                node.view
            }) {
                ForEach(childs, id: \.self) { child in
                    LazyTree(node: child, children: \.children)
                }
                .padding(.leading)
            }
        } else {
            node.view
            .padding(.horizontal)
        }
    }

    init(node: N, children: KeyPath<N, [N]?>) {
        self.node = node
        self.children = children
    }
}
