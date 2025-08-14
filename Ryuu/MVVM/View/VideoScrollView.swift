//
//  VideoScrollView.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//

import SwiftUI
import AVKit
struct VideoScrollView: View {
    let videos: [VideoScene]
    @StateObject private var viewModel: VideoScrollViewModel
    
    init(videos: [VideoScene]) {
        self.videos = videos
        let playerManager = VideoPlayerManager()
        self._viewModel = StateObject(wrappedValue: VideoScrollViewModel(videos: videos, videoPlayerManager: playerManager))
    }
    
    var body: some View {
        GeometryReader { geometry in
            videoContentView(geometry: geometry)
                .onAppear {
                    viewModel.handleViewAppear()
                }
                .onDisappear {
                    viewModel.handleViewDisappear()
                }
        }
        .ignoresSafeArea()
    }
    
    private func videoContentView(geometry: GeometryProxy) -> some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(viewModel.getVideoScenes().enumerated()), id: \.element.id) { index, scene in
                SceneView(
                    scene: scene,
                    player: viewModel.getPlayer(for: scene),
                    isCurrentVideo: index == viewModel.currentIndex,
                    onTap: viewModel.togglePlayPause,
                    viewModel: viewModel
                )
                .frame(height: geometry.size.height)
                .id(index)
            }
        }
        .offset(y: viewModel.calculateVideoOffset(for: geometry.size.height))
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewModel.onScrollStart()
                    viewModel.dragOffset = value.translation.height
                }
                .onEnded { value in
                    let shouldScroll = abs(value.translation.height) > Constants.scrollThreshold ||
                    abs(value.translation.height) > Constants.velocityThreshold
                    
                    if shouldScroll {
                        if value.translation.height > 0 && viewModel.currentIndex > 0 {
                            viewModel.currentIndex -= 1
                        } else if value.translation.height < 0 && viewModel.currentIndex < videos.count - 1 {
                            viewModel.currentIndex += 1
                        }
                    }
                    
                    viewModel.resetDragOffset()
                }
        )
    }
}

struct SceneView: View {
    let scene: VideoScene
    let player: AVPlayer
    let isCurrentVideo: Bool
    let onTap: () -> Void
    @ObservedObject var viewModel: VideoScrollViewModel
    
    var body: some View {
        ZStack {
            VideoPlayerView(player: player)
                .opacity(viewModel.isVideoReady(for: scene.url) ? 1 : 0)
            
            if !viewModel.isVideoReady(for: scene.url) && isCurrentVideo {
                LoadingView(message: viewModel.loadingMessage)
            }
            
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture(perform: onTap)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.checkVideoReady(for: scene.url)
        }
        .onChange(of: player.currentItem?.status) {  newValue in
            viewModel.checkVideoReady(for: scene.url)
        }
    }
}
