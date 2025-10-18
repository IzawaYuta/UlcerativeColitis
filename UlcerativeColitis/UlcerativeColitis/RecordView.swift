//
//  RecordView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/18.
//

import SwiftUI

struct RecordView: View {
    // 親ビューから渡される選択済み日付
    let selectedDate: Date?
    
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            if let date = selectedDate {
                Text("選択日: \(date.formatted(.dateTime.year().month().day()))")
                    .font(.title2)
            } else {
                Text("日付を選択してください")
                    .font(.title2)
            }
            
            HStack {
                Button(action: {
                    count += 1
                }) {
                    Image(systemName: "plus")
                }
                
                Text("\(count)")
            }
        }
        .padding()
    }
}

#Preview {
    RecordView(selectedDate: Date())
}
