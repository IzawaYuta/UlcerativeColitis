//
//  YearPicker.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/18.
//

import SwiftUI

struct YearPicker: View {
    
    @Binding var yearPicker: Int
    
    var doneButton: () -> Void
    var cancelButton: () -> Void
    
    private let years = Array(2000...2100)
    
    var body: some View {
        VStack {
            Picker("年", selection: $yearPicker) {
                ForEach(years, id: \.self) { year in
                    Text("\(String(year))").tag(year)
                }
            }
            .pickerStyle(.wheel)
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}

#Preview {
    YearPicker(yearPicker: .constant(Calendar.current.component(.year, from: Date())), doneButton: {}, cancelButton: {})
}
