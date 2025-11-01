//
//  CustomShadow.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/26.
//

import SwiftUI

struct CustomShadow<Content: View>: View {
    let color: Color
//    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let content: () -> Content
    
    init(
        color: Color = .white,
//        cornerRadius: CGFloat = 10,
        shadowRadius: CGFloat = 3,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.color = color
//        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .shadow(radius: shadowRadius)
            content()
        }
    }
}

#Preview {
    CustomShadow(color: .blue, shadowRadius: 5) {
        VStack {
            Text("Hello")
                .foregroundColor(.white)
                .font(.title)
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
        }
        .padding()
    }
    .frame(width: 200, height: 200)
    .padding()
}
