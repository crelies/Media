//
//  CameraView.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation
import SwiftUI

@available(iOS 13.0, *)
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

    init(captureSession: AVCaptureSession,
         captureSettings: AVCapturePhotoSettings,
         output: AVCapturePhotoOutput) {
        self.captureSession = captureSession
        self.captureSettings = captureSettings
        self.output = output
        self.photograph = Photograph(photoOutput: output, photoSettings: captureSettings)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    if self.stillImageData == nil {
                        ZStack(alignment: .topLeading) {
                            Button(action: {
                                self.isFlashActive.toggle()
                                self.captureSettings.flashMode = self.isFlashActive ? .on : .off
                            }) {
                                Image(systemName: self.isFlashActive ? "bolt.fill" : "bolt.slash.fill")
                                    .frame(width: 48, height: 48)
                            }.padding([.leading, .vertical])
                            .zIndex(1)

                            VideoPreview(captureSession: self.captureSession)
                                .onAppear {
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        self.captureSession.startRunning()
                                    }
                                }
                        }
                    }

                    self.stillImageData.map {
                        UIImage(data: $0).map {
                            Image(uiImage: $0)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }

                    HStack {
                        ZStack(alignment: .center) {
                            Button(action: {
                                self.capture()
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                            }

                            HStack {
                                if self.stillImageData == nil {
                                    Button(action: {
                                        self.finish()
                                    }) {
                                        Text("Cancel")
                                    }
                                } else {
                                    Button(action: {
                                        self.reset()
                                    }) {
                                        Text("Retake")
                                    }
                                }

                                Spacer()

                                Button(action: {
                                    self.save()
                                }) {
                                    Text("Save to library")
                                }.disabled(!self.isLivePhotoAvailable)
                            }.padding(.horizontal)
                        }
                    }
                    .frame(width: geometry.size.width)
                }
            }
            .onDisappear {
                self.onDisappear()
            }
        }
    }
}

@available(iOS 13.0, *)
extension CameraView {
    private func onDisappear() {
        self.reset()
        self.captureSession.stopRunning()
    }

    private func capture() {
        reset()

        photograph.shootPhoto(stillImageCompletion: { stillImageResult in
            switch stillImageResult {
            case .success(let data):
                self.stillImageData = data
            case .failure:
                self.stillImageData = nil
            }
        }) { livePhotoResult in
            switch livePhotoResult {
            case .success(let data):
                self.livePhotoData = data
                self.isLivePhotoAvailable = true
            case .failure:
                self.livePhotoData = nil
                self.isLivePhotoAvailable = false
            }
        }
    }

    private func finish() {
        reset()
        dismiss()
    }

    private func save() {
        if let livePhotoData = livePhotoData {
            try? LivePhoto.save(stillImageData: livePhotoData.stillImageData,
                                livePhotoMovieURL: livePhotoData.movieURL)
            { _ in
                self.finish()
            }
        }
    }
}

@available(iOS 13.0, *)
extension CameraView {
    private func dismiss() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()

            DispatchQueue.main.async {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func reset() {
        stillImageData = nil
        livePhotoData = nil
        isLivePhotoAvailable = false
    }
}
