//
//  CustomBackground.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/24.
//

import SwiftUI

struct CustomBackground: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 200, height: 200)
                .shadow(color: .black.opacity(0.3), radius: 5)
        }
    }
}

#Preview {
    CustomBackground()
}
