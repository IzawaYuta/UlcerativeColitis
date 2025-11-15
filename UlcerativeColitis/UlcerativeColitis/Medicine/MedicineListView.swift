//
//  MedicineInfo.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/27.
//

import SwiftUI
import RealmSwift

struct MedicineListView: View {
    
    @ObservedResults(MedicineInfo.self) var medicineInfo
    @ObservedResults(UnitArray.self) var unitArray
    
    @State private var showMedicineInfoView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // 使用中リスト
                    VStack(alignment: .leading, spacing: 8) {
                        Text("使用中")
                            .font(.headline)
                        
                        if medicineInfo.filter({ $0.isUsing == true }).isEmpty {
                            Text("なし")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(medicineInfo.filter({ $0.isUsing == true }), id: \.id) { list in
                                NavigationLink(destination: MedicineInfoView(medicine: list)) {
                                    CustomList {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(list.medicineName)
                                                    .font(.title3)
                                                    .foregroundColor(.black)
                                                
                                                if let displayText = getStockDisplayText(stock: list.stock, unit: list.unit) {
                                                    HStack {
                                                        Text("残り:")
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                        Text(displayText)
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                            }
                                            
                                            Spacer()
                                            Image(systemName: "chevron.forward")
                                                .foregroundColor(.black)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.black)
                        .padding(.horizontal, 1)
                    
                    // 不使用リスト
                    VStack(alignment: .leading, spacing: 8) {
                        Text("不使用")
                            .font(.headline)
                        
                        if medicineInfo.filter({ $0.isUsing == false }).isEmpty {
                            Text("なし")
                                .foregroundColor(.gray)
                        } else {
                            //                            List {
                            ForEach(medicineInfo.filter({ $0.isUsing == false }), id: \.id) { list in
                                
                                NavigationLink(destination: MedicineInfoView(medicine: list)) {
                                    CustomList {
                                        HStack {
                                            Text(list.medicineName)
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.forward")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("お薬リスト")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbarBackground(Color.gray.opacity(0.1), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: MedicineInfoView(medicine: MedicineInfo())) {
                        Image(systemName: "plus")
                            .foregroundColor(.black.opacity(0.8))
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 35, height: 35)
                            )
                            .padding(.horizontal, 5)
                        //                            .padding(.top)
                    }
                }
            }
        }
    }
    
    private func getStockDisplayText(stock: Int?, unit: UnitArray?) -> String? {
        guard let stock = stock else {
            return nil
        }
        
        let unitText: String
        if let unit = unit {
            unitText = unit.unitName
        } else if let firstUnit = unitArray.first {
            unitText = firstUnit.unitName
        } else {
            unitText = "-"
        }
        
        return "\(stock) \(unitText)"
    }
}

#Preview {
    MedicineListView()
}

struct CustomList<Content: View>: View {
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(height: 50)
                .shadow(color: .gray, radius: 2.5, x: 1.5, y: 1.5)
            content()
        }
        .padding(.horizontal)
    }
}
