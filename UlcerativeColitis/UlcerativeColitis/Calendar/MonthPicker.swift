//
//  MonthPicker.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/21.
//

import SwiftUI

struct MonthPicker: View {
    
    @Binding var monthPicker: Int
    
    var doneButton: () -> Void
    var cancelButton: () -> Void
    
    private let months = Array(1...12)
    
    var body: some View {
        VStack {
            Picker("年", selection: $monthPicker) {
                ForEach(months, id: \.self) { month in
                    Text("\(String(month))").tag(month)
                }
            }
            .pickerStyle(.wheel)
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}

#Preview {
    MonthPicker(monthPicker: .constant(Calendar.current.component(.month, from: Date())), doneButton: {}, cancelButton: {})
}
