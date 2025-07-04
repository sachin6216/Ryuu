//
//  LoadingView.swift
//  Ryuu
//
//  Created by sachin on 04/07/2025.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                CustomText(message, fontSize: 16, alignment: .center)
            }
            .padding(30)
            .background(Color.black.opacity(0.8))
            .cornerRadius(15)
        }
    }
}
