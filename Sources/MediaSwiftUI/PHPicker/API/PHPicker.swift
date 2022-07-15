//
//  PHPicker.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 14.10.20.
//

#if !os(tvOS) && !os(macOS)
import MediaCore
import PhotosUI
import SwiftUI

@available(iOS 14, macCatalyst 14, *)
/// `SwiftUI` port of the `PHPickerViewController`.
public struct PHPicker: UIViewControllerRepresentable {
    /// The coordinator of the view. Mainly it's the delegate of the underlying `PHPickerViewController`.
    public final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let picker: PHPicker

        init(picker: PHPicker) {
            self.picker = picker
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.picker.completion(.success(results))
            picker.dismiss(animated: true, completion: nil)
            self.picker.isPresented = false
        }
    }

    @Binding var isPresented: Bool
    let configuration: PHPickerConfiguration
    let completion: ResultGenericCompletion<[PHPickerResult]>

    /// Initializes the picker.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the picker is presented.
    ///   - configuration: The configuration for the picker.
    ///   - completion: A closure called on completion with a result - an array of `PHPickerResult` on `success` or an `Error` on `failure`.
    public init(
        isPresented: Binding<Bool>,
        configuration: PHPickerConfiguration,
        _ completion: @escaping ResultGenericCompletion<[PHPickerResult]>
    ) {
        _isPresented = isPresented
        self.configuration = configuration
        self.completion = completion
    }

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator
        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: Context
    ) {
        guard !isPresented else {
            return
        }
        uiViewController.dismiss(animated: true, completion: nil)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }
}

@available(iOS 14, macCatalyst 14, *)
struct PHPicker_Previews: PreviewProvider {
    static var previews: some View {
        PHPicker(isPresented: .constant(true), configuration: .init(), { _ in })
    }
}

#endif
