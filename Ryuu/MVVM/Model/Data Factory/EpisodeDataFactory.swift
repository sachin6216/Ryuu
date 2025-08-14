//
//  EpisodeDataFactory.swift
//  Ryuu
//
//  Created by sachin on 04/07/2025.
//

import Foundation
enum EpisodeDataFactory {
    static func createEpisodes() -> [Episode] {
        let episode5Videos = [
            VideoScene(url: "https://theryuu.com/gw1.mp4", title: "Scene 1"),
            VideoScene(url: "https://theryuu.com/gw2.mp4", title: "Scene 2"),
            VideoScene(url: "https://theryuu.com/gw3.mp4", title: "Scene 3"),
            VideoScene(url: "https://theryuu.com/gw4.mp4", title: "Scene 4")
        ]
        
        return [
            Episode(number: 1, title: "Episode 1", thumbnailURL: "https://theryuu.com/bluebird.png", isAvailable: false, videos: [], releaseDate: "Jul 14, 2024"),
            Episode(number: 2, title: "Episode 2", thumbnailURL: "https://theryuu.com/chapter4.png", isAvailable: false, videos: [], releaseDate: "Jul 14, 2024"),
            Episode(number: 3, title: "Episode 3", thumbnailURL: "https://theryuu.com/chapter3.png", isAvailable: false, videos: [], releaseDate: "Jul 14, 2024"),
            Episode(number: 4, title: "Episode 4", thumbnailURL: "https://theryuu.com/chapter2.png", isAvailable: false, videos: [], releaseDate: "Jul 14, 2024"),
            Episode(number: 5, title: "Episode 5", thumbnailURL: "https://theryuu.com/chapter1.png", isAvailable: true, videos: episode5Videos, releaseDate: "Jul 14, 2024")
        ]
    }
}
