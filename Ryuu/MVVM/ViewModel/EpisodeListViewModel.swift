//
//  EpisodeListViewModel.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//

import Foundation
import Combine

// MARK: - Episode List ViewModel
final class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var episodeCountText: String = ""
    @Published var navigationTitle: String = "Granite Waves"
    var errorMessage: String = "This episode is not available yet"
    var episodeNotAbleTxt: String = "Episode Not Available"
    
    init() {
        loadEpisodes()
    }
    
    private func loadEpisodes() {
        episodes = EpisodeDataFactory.createEpisodes()
        episodeCountText = "\(episodes.count) Episodes"
    }
    
    func getStatusText(for episode: Episode) -> String {
        episode.isAvailable ? "NEW" : "SOON"
    }
    
    func getDateText(for episode: Episode) -> String {
        episode.isAvailable ? episode.releaseDate : "Coming Soon"
    }
    
    func canNavigateToEpisode(_ episode: Episode) -> Bool {
        episode.isAvailable
    }
}
