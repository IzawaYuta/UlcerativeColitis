//
//  View1_2.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/22.
//

import SwiftUI

struct View1_2: View {
    
    @Binding var selectDay: Date
    
    var body: some View {
        let color: Double = 247.0
        let rgb = Color(red: color/255, green: color/255, blue: color/255)
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(rgb)
                .shadow(radius: 1)
                .frame(height: 300)
            
            VStack {
                StoolRecordView(selectDay: $selectDay)
                TakingMedicineView(selectDay: $selectDay)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    View1_2(selectDay: .constant(Date()))
        .background(Color.cyan.opacity(0.1))
}
