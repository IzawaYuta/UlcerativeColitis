//
//  CustomAddButtonView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/26.
//

import SwiftUI

struct CustomAddButtonView<Content: View>: View {
    let color: Color
    let shadowRadius: CGFloat
    let isPresented: Bool
    let action: () -> Void
    let content: () -> Content
    
    init(
        color: Color = .white,
        shadowRadius: CGFloat = 3,
        isPresented: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.color = color
        self.shadowRadius = shadowRadius
        self.isPresented = isPresented
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Capsule()
                    .fill(color)
                    .shadow(radius: shadowRadius)
                    .overlay(
                        Capsule()
                            .stroke(isPresented ? Color.black.opacity(0.7) : Color.clear, lineWidth: 2.0)
                    )
                content()
                    .foregroundColor(isPresented ? .black : .gray)
//                    .padding(.vertical)
//                    .padding(.horizontal)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isPresented ? 1.1 : 0.8)
        .animation(.none, value: isPresented)
    }
}

#Preview {
    CustomAddButtonView(color: .blue, shadowRadius: 3, action: {
    }) {
        Image(systemName: "plus")
            .foregroundColor(.white)
            .font(.system(size: 30))
            .padding()
    }
    .frame(width: 200, height: 100)
    .padding()
}
