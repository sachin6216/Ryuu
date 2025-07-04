//
//  RyuuApp.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
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
