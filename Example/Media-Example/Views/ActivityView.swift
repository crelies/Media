//
//  ActivityView.swift
//  Media-Example
//
//  Created by Christian Elies on 24.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct ActivityView<T: AnyObject>: UIViewControllerRepresentable {
    let activityItems: [T]
    let applicationActivities: [UIActivity]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView<T>>) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView<T>>) {

    }
}
