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
            HStack(spacing: 30) {
                Image(systemName: "pills")
                    .foregroundColor(.green)
                    .background(
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 40, height: 40)
                    )
                VStack {
                    Text("服用")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("服用あり")
                }
                
                Spacer()
                
                Button(action: {
                    showAddTakingMedicineView.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(width: 40, height: 40)
                        )
                }
                .sheet(isPresented: $showAddTakingMedicineView) {
                    AddTakingMedicineListView(selectDay: $selectDay, addButton: { showAddTakingMedicineView = false })
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
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    TakingMedicineView(selectDay: .constant(Date()))
        .background(Color.cyan.opacity(0.1))
}
