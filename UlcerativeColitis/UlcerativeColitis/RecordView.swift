//
//  RecordView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/18.
//

import SwiftUI

struct RecordView: View {
    // 親ビューから渡される選択済み日付
    let selectedYear: Date?
    let selectedMonth: Date?
    let selectedDate: Date?
    
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
                        if let year = selectedYear {
            Text("選択日: \(year.formatted(.dateTime.year()))")
                .font(.title2)
        }
            
            if let month = selectedMonth {
                Text("選択日: \(month.formatted(.dateTime.month()))")
                    .font(.title2)
            }

            if let date = selectedDate {
                Text("選択日: \(date.formatted(.dateTime.day()))")
                    .font(.title2)
            }

//            } else {
//                Text("日付を選択してください")
//                    .font(.title2)
//            }
            
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
    RecordView(selectedYear: Date(), selectedMonth: Date(), selectedDate: Date())
}
