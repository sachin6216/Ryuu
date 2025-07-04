//
//  AppTheme.swift
//  Ryuu
//
//  Created by sachin on 04/07/2025.
//
import SwiftUI

enum DesignSystem {
    enum Colors {
        static let primary = Color.white
        static let secondary = Color(red: 0.56, green: 0.56, blue: 0.56)
        static let accent = Color(red: 0.12, green: 0.74, blue: 0.63)
        static let background = Color(red: 0.098, green: 0.098, blue: 0.098)
        static let surfaceBackground = Color(red: 0.047, green: 0.047, blue: 0.047)
    }
    
    enum Fonts {
        static let regular = "Questrial-Regular"
    }
    
    enum Spacing {
        static let small: CGFloat = 5
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
    }
    
    enum Dimensions {
        static let thumbnailSize: CGFloat = 82
        static let cornerRadius: CGFloat = 5
        static let thumbnailCornerRadius: CGFloat = 3.7
    }
}
enum Constants {
    static let preloadBuffer = 2
    static let scrollThreshold: CGFloat = 100
    static let velocityThreshold: CGFloat = 500
    static let animationDuration: Double = 0.3
    static let loadingTimeout: Double = 10.0
}
