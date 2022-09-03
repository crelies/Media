//
//  LivePhotoCameraView.swift
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
@available(macCatalyst 14, *)
struct LivePhotoCameraView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: LivePhotoCameraViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    if let stillImageData = viewModel.stillImageData, let uiImage = UIImage(data: stillImageData) {
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
@available(macCatalyst 14, *)
private extension LivePhotoCameraView {
    func stillImageView(uiImage: UIImage, geometry: GeometryProxy) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }

    func captureView() -> some View {
        ZStack(alignment: .topLeading) {
            topToolbar()

            VideoPreview(captureSession: viewModel.captureSession)
                .onAppear {
                    viewModel.startVideoPreview()
                }
        }
    }

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
                        viewModel.useLivePhoto()
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
