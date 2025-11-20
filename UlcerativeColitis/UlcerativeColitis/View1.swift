//
//  View1.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/20.
//

import SwiftUI

struct View1: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.08)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        CalendarView2()
                        Spacer()
                    }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Text("記録画面")
//                }
//            }
        }
    }
}

#Preview {
    View1()
}
