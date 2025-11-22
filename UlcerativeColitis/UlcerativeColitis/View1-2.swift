//
//  View1-2.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/22.
//

import SwiftUI

struct View1_2: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 300)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    View1_2()
        .background(Color.cyan.opacity(0.1))
}
