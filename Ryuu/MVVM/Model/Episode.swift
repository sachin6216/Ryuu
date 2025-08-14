//
//  Episode.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//
import Foundation

struct Episode: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let thumbnailURL: String
    let isAvailable: Bool
    let videos: [VideoScene]
    let releaseDate: String
}

