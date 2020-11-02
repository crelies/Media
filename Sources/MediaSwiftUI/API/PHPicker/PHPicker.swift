//
//  PHPicker.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 14.10.20.
//

#if !os(tvOS)
import MediaCore
import PhotosUI
import SwiftUI

@available(iOS 14, macOS 11, macCatalyst 14, *)
public struct PHPicker: UIViewControllerRepresentable {
    public final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let picker: PHPicker

        init(picker: PHPicker) {
            self.picker = picker
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.picker.completion(.success(results))
            picker.dismiss(animated: true, completion: nil)
        }
    }

    let configuration: PHPickerConfiguration
    let completion: ResultGenericCompletion<[PHPickerResult]>

    public init(
        configuration: PHPickerConfiguration,
        _ completion: @escaping ResultGenericCompletion<[PHPickerResult]>
    ) {
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
    ) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }
}

#if DEBUG
@available(iOS 14, macOS 11, macCatalyst 14, *)
struct PHPicker_Previews: PreviewProvider {
    static var previews: some View {
        PHPicker(configuration: .init(), { _ in })
    }
}
#endif

#endif
