//
//  TimeView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/03.
//

import SwiftUI
import RealmSwift

struct TimeView: View {
    
    
    @State private var time: Date = Date()
    
    var done: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
            Button(action: {
//                saveTime()
                done()
            }) {
                Text("保存")
                    .foregroundColor(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 30)
                    )
            }
        }
        .padding()
    }
    
}

//#Preview {
//    TimeView(medicine: m, done: {})
//}
