//
//  EpisodeSelectionView.swift
//  Ryuu
//
//  Created by sachin on 03/07/2025.
//

import SwiftUI
import AVKit

struct EpisodeSelectionView: View {
    @StateObject private var viewModel = EpisodeListViewModel()
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TopBarView(title: viewModel.navigationTitle)
                
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.small) {
                        CustomText(viewModel.episodeCountText, fontSize: 20)
                            .padding(.vertical, 20)
                            .padding(.leading, DesignSystem.Spacing.large)
                        
                        ForEach(viewModel.episodes) { episode in
                            EpisodeRowView(
                                episode: episode,
                                statusText: viewModel.getStatusText(for: episode),
                                statusColor:  episode.isAvailable ? .white : Color(red: 0.12, green: 0.74, blue: 0.63),
                                dateText: viewModel.getDateText(for: episode),
                                canNavigate: viewModel.canNavigateToEpisode(episode)
                            )
                            .onTapGesture {
                                if !episode.isAvailable {
                                    showingError = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .alert(viewModel.episodeNotAbleTxt, isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct EpisodeRowView: View {
    let episode: Episode
    let statusText: String
    let statusColor: Color
    let dateText: String
    let canNavigate: Bool
    
    var body: some View {
        let content = HStack {
            AsyncImageView(
                url: episode.thumbnailURL,
                width: DesignSystem.Dimensions.thumbnailSize,
                height: DesignSystem.Dimensions.thumbnailSize,
                cornerRadius: DesignSystem.Dimensions.thumbnailCornerRadius
            )
            .padding(.leading, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.small)
            
            VStack(alignment: .leading, spacing: 4) {
                CustomText(episode.title, fontSize: 16)
                CustomText(dateText, fontSize: 12, color: DesignSystem.Colors.secondary)
            }
            
            Spacer()
            
            CustomText(statusText, fontSize: 16, color: statusColor, alignment: .trailing)
                .padding(.trailing, DesignSystem.Spacing.medium)
        }
            .background(DesignSystem.Colors.background)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius))
        
        if canNavigate {
            NavigationLink(destination: VideoScrollView(videos: episode.videos)) {
                content
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            content
        }
    }
}

struct TopBarView: View {
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.leading, DesignSystem.Spacing.large)
            
            CustomText(title, fontSize: 16, alignment: .center)
        }
    }
}

