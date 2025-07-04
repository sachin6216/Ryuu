//
//  VideoScrollViewModel.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//

import AVKit
import Combine

final class VideoScrollViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentIndex: Int = 0
    @Published var isScrolling: Bool = false
    @Published var dragOffset: CGFloat = 0
    @Published private var videoReadyStates: [String: Bool] = [:]
    @Published var loadingMessage: String = "Loading videos..."
    
    // MARK: - Private Properties
    private let videoPlayerManager: any VideoPlayerManaging
    private let videos: [VideoScene]
    private var cancellables = Set<AnyCancellable>()
    
    init(videos: [VideoScene], videoPlayerManager: any VideoPlayerManaging) {
        self.videos = videos
        self.videoPlayerManager = videoPlayerManager
        
        setupObservers()
        setupVideoReadyObserver()
        preloadInitialVideos()
    }
    
    private func setupObservers() {
        Publishers.CombineLatest($currentIndex, $isScrolling)
            .sink { [weak self] index, scrolling in
                self?.handleStateChange(index: index, isScrolling: scrolling)
            }
            .store(in: &cancellables)
    }
    
    private func setupVideoReadyObserver() {
        videoPlayerManager.videoReadyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url, isReady in
                self?.videoReadyStates[url] = isReady
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(index: Int, isScrolling: Bool) {
        guard index < videos.count else { return }
        
        preloadAdjacentVideos(for: index)
        
        if isScrolling {
            videoPlayerManager.pauseAllVideos()
        } else {
            playCurrentVideo()
        }
    }
    
    private func preloadInitialVideos() {
        let videosToPreload = min(Constants.preloadBuffer, videos.count)
        (0..<videosToPreload).forEach { index in
            videoPlayerManager.preloadVideo(url: videos[index].url)
        }
    }
    
    private func preloadAdjacentVideos(for index: Int) {
        if index + 1 < videos.count {
            videoPlayerManager.preloadVideo(url: videos[index + 1].url)
        }
        
        if index - 1 >= 0 {
            videoPlayerManager.preloadVideo(url: videos[index - 1].url)
        }
    }
    
    func resetDragOffset() {
        dragOffset = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDuration) { [weak self] in
            self?.onScrollEnd()
        }
    }
    
    // MARK: - Public Methods
    func togglePlayPause() {
        guard currentIndex < videos.count else { return }
        videoPlayerManager.togglePlayPause(url: videos[currentIndex].url)
    }
    
    func playCurrentVideo() {
        guard currentIndex < videos.count else { return }
        videoPlayerManager.playVideo(url: videos[currentIndex].url)
    }
    
    func onScrollEnd() {
        isScrolling = false
    }
    
    func onScrollStart() {
        isScrolling = true
    }
    
    func getPlayer(for videoScene: VideoScene) -> AVPlayer {
        videoPlayerManager.getPlayer(for: videoScene.url)
    }
    
    func calculateVideoOffset(for screenHeight: CGFloat) -> CGFloat {
        -CGFloat(currentIndex) * screenHeight + dragOffset
    }
    
    func handleViewAppear() {
        playCurrentVideo()
    }
    
    func handleViewDisappear() {
        onScrollEnd()
    }
    
    func getVideoScenes() -> [VideoScene] {
        videos
    }
    
    // MARK: - Video Ready State Management
    func isVideoReady(for url: String) -> Bool {
        return videoReadyStates[url] ?? false
    }
    
    func checkVideoReady(for url: String) {
        let player = videoPlayerManager.getPlayer(for: url)
        let isReady = player.currentItem?.status == .readyToPlay
        videoReadyStates[url] = isReady
    }
}
