//
//  VideoPlayerManager.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

protocol VideoPlayerManaging: ObservableObject {
    var videoReadyPublisher: AnyPublisher<(String, Bool), Never> { get }
    
    func getPlayer(for url: String) -> AVPlayer
    func preloadVideo(url: String)
    func playVideo(url: String)
    func pauseAllVideos()
    func pauseVideo(url: String)
    func togglePlayPause(url: String)
    func isPlaying(url: String) -> Bool
    func isVideoReady(for url: String) -> Bool
}

final class VideoPlayerManager: VideoPlayerManaging {
    private var players: [String: AVPlayer] = [:]
    private var observers: [String: [NSObjectProtocol]] = [:]
    private var videoReadyStates: [String: Bool] = [:]
    private let readyStateSubject = PassthroughSubject<(String, Bool), Never>()
    
    var videoReadyPublisher: AnyPublisher<(String, Bool), Never> {
        readyStateSubject.eraseToAnyPublisher()
    }
    
    func getPlayer(for url: String) -> AVPlayer {
        if let existingPlayer = players[url] {
            return existingPlayer
        }
        
        let player = createPlayer(for: url)
        players[url] = player
        videoReadyStates[url] = false
        setupObservers(for: player, url: url)
        
        return player
    }
    
    private func createPlayer(for url: String) -> AVPlayer {
        guard let videoURL = URL(string: url) else {
            fatalError("Invalid URL: \(url)")
        }
        return AVPlayer(url: videoURL)
    }
    
    private func setupObservers(for player: AVPlayer, url: String) {
        var playerObservers: [NSObjectProtocol] = []
        
        let loopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.restartPlayer(for: url)
        }
        
        if let currentItem = player.currentItem {
            let readyObserver = currentItem.observe(\.status, options: [.new]) { [weak self] item, _ in
                self?.handlePlayerItemStatusChange(item: item, url: url)
            }
            playerObservers.append(readyObserver)
        }
        
        playerObservers.append(loopObserver)
        observers[url] = playerObservers
    }
    
    private func handlePlayerItemStatusChange(item: AVPlayerItem, url: String) {
        switch item.status {
        case .readyToPlay:
            updateVideoReadyState(url: url, isReady: true)
        case .failed:
            print("Failed to load video: \(url)")
            updateVideoReadyState(url: url, isReady: false)
        case .unknown:
            break
        @unknown default:
            break
        }
    }
    
    private func updateVideoReadyState(url: String, isReady: Bool) {
        videoReadyStates[url] = isReady
        readyStateSubject.send((url, isReady))
    }
    
    private func restartPlayer(for url: String) {
        players[url]?.seek(to: .zero)
        players[url]?.play()
    }
    
    func preloadVideo(url: String) {
        let player = getPlayer(for: url)
        player.currentItem?.preferredForwardBufferDuration = 5.0
        player.automaticallyWaitsToMinimizeStalling = false
    }
    
    func playVideo(url: String) {
        pauseAllVideos()
        players[url]?.play()
    }
    
    func pauseAllVideos() {
        players.values.forEach { $0.pause() }
    }
    
    func pauseVideo(url: String) {
        players[url]?.pause()
    }
    
    func togglePlayPause(url: String) {
        guard let player = players[url] else { return }
        
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            pauseAllVideos()
            player.play()
        }
    }
    
    func isPlaying(url: String) -> Bool {
        players[url]?.timeControlStatus == .playing
    }
    
    func isVideoReady(for url: String) -> Bool {
        videoReadyStates[url] ?? false
    }
    
    deinit {
        observers.values.forEach { observerArray in
            observerArray.forEach { observer in
                if let keyValueObserver = observer as? NSKeyValueObservation {
                    keyValueObserver.invalidate()
                } else {
                    NotificationCenter.default.removeObserver(observer)
                }
            }
        }
    }
}
