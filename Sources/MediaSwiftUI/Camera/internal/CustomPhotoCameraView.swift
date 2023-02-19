//
//  CustomPhotoCameraView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 17.01.20.
//

#if !os(tvOS)
import AVFoundation
import MediaCore
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@available(iOS 13, *)
@available(macOS 11, *)
@available(macCatalyst 14, *)
struct CustomPhotoCameraView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: PhotoCameraViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    if let stillImageData = viewModel.stillImageData, let uiImage = UniversalImage(data: stillImageData) {
                        stillImageView(uiImage: uiImage, geometry: geometry)
                    } else {
                        captureView()
                    }

                    bottomToolbar()
                        .frame(width: geometry.size.width)
                }
            }
            .onDisappear(perform: viewModel.onDisappear)
        }
    }
}

@available(iOS 13, *)
@available(macOS 11, *)
@available(macCatalyst 14, *)
private extension CustomPhotoCameraView {
    func stillImageView(uiImage: UniversalImage, geometry: GeometryProxy) -> some View {
        Image(universalImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }

    func captureView() -> some View {
        ZStack(alignment: .topLeading) {
            // TODO: iOS 13?
            if #available(iOS 14, macOS 13, *) {
                topToolbar()
            }

            #if !os(macOS)
            VideoPreview(captureSession: viewModel.captureSession)
                .onAppear {
                    viewModel.startVideoPreview()
                }
            #endif
        }
    }

    @available(macOS 13, *)
    func topToolbar() -> some View {
        HStack {
            Button(action: viewModel.toggleFlashMode) {
                Image(systemName: viewModel.isFlashActive ? "bolt.fill" : "bolt.slash.fill")
                    .frame(width: 48, height: 48)
            }
            .padding([.leading, .vertical])

            Spacer()

            Button(action: viewModel.toggleCamera) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .frame(width: 48, height: 48)
            }
            .padding([.trailing, .vertical])
        }
        .zIndex(1)
    }

    func bottomToolbar() -> some View {
        HStack {
            ZStack(alignment: .center) {
                Button(action: viewModel.capture) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }

                HStack {
                    Button(action: {
                        if viewModel.stillImageData == nil {
                            viewModel.finish()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.finish()
                        }
                    }) {
                        Text(viewModel.stillImageData == nil ? "Cancel" : "Retake")
                    }

                    Spacer()

                    Button(action: {
                        viewModel.useCapturedPhoto()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack {
                            Text("Use LivePhoto")

                            if viewModel.stillImageData != nil && !viewModel.isLivePhotoAvailable {
                                Text("Processing ...")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }.disabled(!viewModel.isLivePhotoAvailable)
                }.padding(.horizontal)
            }
        }
    }
}
#endif
