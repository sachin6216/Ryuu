//
//  RyuuApp.swift
//  Ryuu
//
//  Created by Sachin on 14/08/2025.
//

import SwiftUI

@main
struct RyuuApp: App {
    var body: some Scene {
        WindowGroup {
            EpisodeSelectionView()
                .preferredColorScheme(.dark)
        }
    }
}
