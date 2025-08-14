//
//  CustomText.swift
//  Ryuu
//
//  Created by sachin on 04/07/2025.
//

import SwiftUI
struct CustomText: View {
    let text: String
    let fontSize: CGFloat
    let color: Color
    let alignment: Alignment
    
    init(_ text: String, fontSize: CGFloat, color: Color = DesignSystem.Colors.primary, alignment: Alignment = .leading) {
        self.text = text
        self.fontSize = fontSize
        self.color = color
        self.alignment = alignment
    }
    
    var body: some View {
        Text(text)
            .font(.custom(DesignSystem.Fonts.regular, size: fontSize))
            .foregroundColor(color)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}
