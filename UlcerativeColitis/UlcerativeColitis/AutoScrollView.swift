//
//  AutoScrollView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/08.
//

import SwiftUI

struct AutoScrollView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    @State private var contentHeight: CGFloat = 0
    @State private var containerHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { outerGeo in
            let containerHeight = outerGeo.size.height
            
            ScrollView(showsIndicators: true) {
                VStack {
                    GeometryReader { innerGeo in
                        Color.clear
                            .onAppear {
                                contentHeight = innerGeo.size.height
                            }
                            .onChange(of: innerGeo.size.height) { newHeight in
                                contentHeight = newHeight
                            }
                    }
                    .frame(height: 0)
                    
                    content()
                }
            }
            // スクロールの有無を切り替える
            .disabled(contentHeight <= containerHeight)
        }
    }
}

//#Preview {
//    AutoScrollView()
//}
