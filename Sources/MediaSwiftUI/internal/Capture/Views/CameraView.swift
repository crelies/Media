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
@available(macCatalyst 14, *)
struct CameraView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: CameraViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    if let stillImageData = viewModel.stillImageData, let uiImage = UIImage(data: stillImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        ZStack(alignment: .topLeading) {
                            Button(action: viewModel.toggleFlashMode) {
                                Image(systemName: viewModel.isFlashActive ? "bolt.fill" : "bolt.slash.fill")
                                    .frame(width: 48, height: 48)
                            }
                            .padding([.leading, .vertical])
                            .zIndex(1)

                            VideoPreview(captureSession: viewModel.captureSession)
                                .onAppear {
                                    viewModel.startVideoPreview()
                                }
                        }
                    }

                    toolbar()
                    .frame(width: geometry.size.width)
                }
            }
            .onDisappear(perform: viewModel.onDisappear)
        }
    }
}

@available(iOS 13, *)
@available(macCatalyst 14, *)
private extension CameraView {
    func toolbar() -> some View {
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
                        viewModel.finish()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(viewModel.stillImageData == nil ? "Cancel" : "Retake")
                    }

                    Spacer()

                    Button(action: {
                        viewModel.useLivePhoto()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Use LivePhoto")
                    }.disabled(!viewModel.isLivePhotoAvailable)
                }.padding(.horizontal)
            }
        }
    }
}
#endif
