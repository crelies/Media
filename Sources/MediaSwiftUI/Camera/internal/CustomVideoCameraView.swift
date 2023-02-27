//
//  CustomVideoCameraView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 19/02/2023.
//

#if os(macOS) || os(iOS)
import AVFoundation
import AVKit
import MediaCore
import SwiftUI

@available(iOS 14, *)
@available(macOS 11, *)
struct CustomVideoCameraView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: VideoCameraViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
//                ZStack(alignment: .bottom) {
                    if let videoURL = viewModel.videoURL {
                        VideoPlayer(player: .init(url: videoURL))
                    } else {
                        captureView()
                    }

                    bottomToolbar()
                        .frame(width: geometry.size.width)
//                }
            }
        }
        // Attach the disappear modifier here instead on the VStack (macOS issue)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

@available(iOS 14, *)
@available(macOS 11, *)
private extension CustomVideoCameraView {
    func captureView() -> some View {
        ZStack(alignment: .topLeading) {
            if #available(macOS 13, *) {
                topToolbar()
            }

            VideoPreview(captureSession: viewModel.captureSession)
                .onAppear {
                    viewModel.startVideoPreview()
                }
        }
    }

    func topToolbar() -> some View {
        HStack {
            if #available(macOS 13, *) {
                Button(action: viewModel.toggleFlashMode) {
                    Image(systemName: viewModel.isFlashActive ? "bolt.fill" : "bolt.slash.fill")
                        .frame(width: 48, height: 48)
                }
                .padding([.leading, .vertical])

                Spacer()
            }

            Button(action: viewModel.toggleCamera) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .frame(width: 48, height: 48)
            }
            .padding([.trailing, .vertical])
        }
        .zIndex(1)
    }

    func recordButton() -> some View {
        Button(action: {
            switch viewModel.state {
            case .idle:
                viewModel.record()
            case .recording:
                viewModel.stop()
            default: ()
            }
        }) {
            Image(systemName: viewModel.state == .recording ? "stop.circle" : "record.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                #if !os(macOS)
                .frame(width: 60, height: 60)
                #endif
                .foregroundColor(viewModel.state != .recording ? Color(.systemRed) : .accentColor)
        }
    }

    @available(iOS, unavailable)
    func pauseButton() -> some View {
        Button(action: {
            switch viewModel.state {
            case .recording:
                viewModel.pause()
            case .paused:
                viewModel.resume()
            default: ()
            }
        }) {
            Image(systemName: viewModel.state == .recording ? "pause.circle" : "play.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                #if !os(macOS)
                .frame(width: 60, height: 60)
                #endif
                .foregroundColor(viewModel.state != .recording ? Color(.systemRed) : .accentColor)
        }
    }

    func bottomToolbar() -> some View {
        HStack {
            ZStack(alignment: .center) {
                HStack {
                    if viewModel.state != .paused {
                        recordButton()
                    }

                    #if !os(iOS)
                    if viewModel.state != .idle {
                        pauseButton()
                    }
                    #endif
                }

                HStack {
                    Button(action: {
                        if viewModel.videoURL == nil {
                            viewModel.finish()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.finish()
                        }
                    }) {
                        Text(viewModel.videoURL == nil ? "Cancel" : "Retake")
                    }

                    Spacer()

                    Button(action: {
                        viewModel.useCapturedVideo()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack {
                            Text("Use")

                            if viewModel.videoURL != nil && !viewModel.isCapturedVideoAvailable {
                                Text("Processing ...")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }.disabled(!viewModel.isCapturedVideoAvailable)
                }.padding(.horizontal)
            }
        }
    }
}
#endif
