//
//  MedicineCustomBack.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/02.
//

import SwiftUI

struct MedicineCustomBack<Content: View>: View {
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
            content()
                .padding(.vertical)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

//#Preview {
//    MedicineCustomBack()
//}
