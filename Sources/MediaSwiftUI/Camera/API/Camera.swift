//
//  Camera.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import MediaCore
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
/// Type which provides a ready-to-use SwiftUI view
///
public struct Camera {
    /// A ready-to-use `SwiftUI` camera view which returns the URL to the
    /// captured media on `success`
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter selection: A binding which represents the camera result.
    ///
    /// - Returns: some View
    public static func view(selection: Binding<Camera.Result?>) -> some View {
        view(
            errorView: { error in Text(error.localizedDescription) },
            selection: selection
        )
    }

    /// A ready-to-use `SwiftUI` camera view which returns the URL to the
    /// captured media on `success`
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter selection: A binding which represents the camera result.
    ///
    /// - Returns: some View
    @ViewBuilder
    public static func view<ErrorView: View>(@ViewBuilder errorView: (Swift.Error) -> ErrorView, selection: Binding<Camera.Result?>) -> some View {
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        let result = Swift.Result {
            try availableMediaTypes.map( { try UIImagePickerController.MediaType(string: $0) })
        }
        switch result {
        case let .success(mediaTypes):
            ViewCreator.camera(
                for: Set(mediaTypes),
                selection: .writeOnly({ result in
                    switch result {
                    case let .success(cameraResult):
                        selection.wrappedValue = cameraResult
                    case let .failure(error):
                        // TODO: error handling
                        debugPrint(error)
                    case .none: ()
                    }
                })
            )
        case let .failure(error):
            Text(error.localizedDescription)
        }
    }
}
#endif
