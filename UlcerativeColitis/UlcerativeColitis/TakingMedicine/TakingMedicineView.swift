//
//  TakingMedicineView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/24.
//

import SwiftUI

struct TakingMedicineView: View {
    
    @State private var showAddTakingMedicineView = false
    @State private var showTakingMedicineListView = false
    
    @Binding var selectDay: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(height: 100)
            HStack {
                Button(action: {
                    showAddTakingMedicineView.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showAddTakingMedicineView) {
                    AddTakingMedicineListView(selectDay: $selectDay)
                }
                
                Button(action: {
                    showTakingMedicineListView.toggle()
                }) {
                    Image(systemName: "list.bullet")
                }
                .sheet(isPresented: $showTakingMedicineListView) {
                    TakingMedicineListView(selectDay: $selectDay)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    TakingMedicineView(selectDay: .constant(Date()))
        .background(Color.cyan.opacity(0.1))
}
