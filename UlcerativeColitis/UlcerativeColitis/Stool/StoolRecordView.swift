//
//  StoolRecordView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/22.
//

import SwiftUI

struct StoolRecordView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 1)
                .frame(height: 100)
            HStack {
                Image(systemName: "plus.circle")
                VStack {
                    Text("排便回数")
                    Text("何回")
                }
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    StoolRecordView()
        .background(Color.cyan.opacity(0.1))
}
