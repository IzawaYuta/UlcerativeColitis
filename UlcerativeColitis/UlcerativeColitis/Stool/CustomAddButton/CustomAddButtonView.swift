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
    @Binding var isPresented: Bool
//    let action: () -> Void
    let content: () -> Content
    
    init(
        color: Color,
        shadowRadius: CGFloat = 3,
//        isPresented: Bool = false,
        isPresented: Binding<Bool>,   // ← Binding を受け取る
//        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.color = color
        self.shadowRadius = shadowRadius
//        self.isPresented = isPresented
//        self.action = action
        self._isPresented = isPresented   // ← Binding をセット
        self.content = content
    }
    
    var body: some View {
//        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isPresented ? color.opacity(0.7) : color.opacity(0.3))
//                    .shadow(radius: shadowRadius)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(isPresented ? Color.black.opacity(0.7) : Color.clear, lineWidth: 2.0)
//                    )
                content()
                    .foregroundColor(/*isPresented ? */.black/* : .gray*/)
//                    .padding(.vertical)
//                    .padding(.horizontal)
            }
//        }
//        .buttonStyle(.plain)
            .onTapGesture {
                isPresented.toggle()
            }
        .scaleEffect(isPresented ? 1.0 : 0.8)
        .animation(.linear, value: isPresented)
    }
}

//#Preview {
//    CustomAddButtonView(color: .blue, shadowRadius: 3, action: {
//    }) {
//        Image(systemName: "plus")
//            .foregroundColor(.white)
//            .font(.system(size: 30))
//            .padding()
//    }
//    .frame(width: 200, height: 100)
//    .padding()
//}
