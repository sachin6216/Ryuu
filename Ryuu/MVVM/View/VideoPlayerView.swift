//
//  VideoPlayerView.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//

import Foundation
import UIKit
import SwiftUI
import AVKit

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            DispatchQueue.main.async {
                playerLayer.frame = uiView.bounds
            }
        }
    }
}
