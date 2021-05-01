//
//  CameraView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 17.01.20.
//

#if canImport(UIKit) && !os(tvOS)
import AVFoundation
import MediaCore
import SwiftUI
import UIKit

@available(iOS 13, *)
struct CameraView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var isLivePhotoAvailable = false
    @State private var isFlashActive: Bool = false
    @State private var stillImageData: Data?
    @State private var livePhotoData: LivePhotoData?

    private let captureSession: AVCaptureSession
    private let captureSettings: AVCapturePhotoSettings
    private let output: AVCapturePhotoOutput
    private let photograph: Photograph
    private let completion: LivePhotoDataCompletion

    init(captureSession: AVCaptureSession,
         captureSettings: AVCapturePhotoSettings,
         output: AVCapturePhotoOutput,
         _ completion: @escaping LivePhotoDataCompletion) {
        self.captureSession = captureSession
        self.captureSettings = captureSettings
        self.output = output
        self.photograph = Photograph(photoOutput: output, photoSettings: captureSettings)
        self.completion = completion
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    if let stillImageData = stillImageData, let uiImage = UIImage(data: stillImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        ZStack(alignment: .topLeading) {
                            Button(action: toggleFlashMode) {
                                Image(systemName: isFlashActive ? "bolt.fill" : "bolt.slash.fill")
                                    .frame(width: 48, height: 48)
                            }
                            .padding([.leading, .vertical])
                            .zIndex(1)

                            VideoPreview(captureSession: captureSession)
                                .onAppear {
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        captureSession.startRunning()
                                    }
                                }
                        }
                    }

                    toolbar()
                    .frame(width: geometry.size.width)
                }
            }
            .onDisappear(perform: onDisappear)
        }
    }
}

@available(iOS 13, *)
private extension CameraView {
    func toolbar() -> some View {
        HStack {
            ZStack(alignment: .center) {
                Button(action: capture) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }

                HStack {
                    if stillImageData == nil {
                        Button(action: finish) {
                            Text("Cancel")
                        }
                    } else {
                        Button(action: reset) {
                            Text("Retake")
                        }
                    }

                    Spacer()

                    Button(action: useLivePhoto) {
                        Text("Use LivePhoto")
                    }.disabled(!isLivePhotoAvailable)
                }.padding(.horizontal)
            }
        }
    }
}

@available(iOS 13, *)
private extension CameraView {
    func onDisappear() {
        reset()
        captureSession.stopRunning()
    }

    func toggleFlashMode() {
        isFlashActive.toggle()
        captureSettings.flashMode = isFlashActive ? .on : .off
    }

    func capture() {
        reset()

        photograph.shootPhoto(stillImageCompletion: { stillImageResult in
            switch stillImageResult {
            case .success(let data):
                stillImageData = data
            case .failure:
                stillImageData = nil
            }
        }) { livePhotoResult in
            switch livePhotoResult {
            case .success(let data):
                livePhotoData = data
                isLivePhotoAvailable = true
            case .failure:
                livePhotoData = nil
                isLivePhotoAvailable = false
            }
        }
    }

    func finish() {
        reset()
        dismiss()
    }

    func useLivePhoto() {
        if let livePhotoData = livePhotoData {
            completion(.success(livePhotoData))
            finish()
        }
    }
}

@available(iOS 13, *)
private extension CameraView {
    func dismiss() {
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.stopRunning()

            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func reset() {
        stillImageData = nil
        livePhotoData = nil
        isLivePhotoAvailable = false
    }
}
#endif
