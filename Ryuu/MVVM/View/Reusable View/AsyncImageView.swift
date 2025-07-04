//
//  AsyncImageView.swift
//  Ryuu
//
//  Created by sachin on 04/07/2025.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(DesignSystem.Colors.secondary.opacity(0.3))
                .overlay(
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.primary))
                )
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
