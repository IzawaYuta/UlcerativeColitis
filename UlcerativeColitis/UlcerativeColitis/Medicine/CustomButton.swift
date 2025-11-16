//
//  CustomButton.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/27.
//

import SwiftUI

struct CustomButton<Content: View>: View {
    let color: Color
    let shadowRadius: CGFloat
    let selected: Set<FirstTiming>
    let action: () -> Void
    let content: () -> Content
    let timing: FirstTiming
    
    init(
        color: Color = .white,
        shadowRadius: CGFloat = 3,
        selected: Set<FirstTiming> = [],
        timing: FirstTiming = .morning,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.color = color
        self.shadowRadius = shadowRadius
        self.selected = selected
        self.action = action
        self.content = content
        self.timing = timing
    }
    
    var body: some View {
        let isSelected = selected.contains(timing)
        
        Button(action: action) {
            ZStack {
                Capsule()
                    .fill(color)
                    .shadow(radius: shadowRadius)
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 1.0)
                    )
                content()
                    .foregroundColor(isSelected ? .black : .gray.opacity(0.5))
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.0 : 0.9)
    }
}
