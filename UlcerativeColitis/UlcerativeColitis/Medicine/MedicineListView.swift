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
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 50) {
                    Text("使用中")
                        .foregroundColor(selectedTab == 0 ? .primary : .gray)
                        .onTapGesture {
                            selectedTab = 0
                        }
                        .frame(width: 80)
                    
                    Text("不使用")
                        .foregroundColor(selectedTab == 1 ? .primary : .gray)
                        .onTapGesture {
                            selectedTab = 1
                        }
                        .frame(width: 80)
                }
                .overlay(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .shadow(color: .blue, radius: 1)
                        .shadow(color: .blue, radius: 0.5, x: 0.5, y: 0.5)
                        .shadow(color: .blue, radius: 0.1, x: 0.2, y: 0.2)
                        .frame(width: 80, height: 2)
                        .offset(x: selectedTab == 0 ? 0 : 130, y: 10)
                        .animation(.spring(response: 0.3), value: selectedTab)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // 使用中リスト
                        if selectedTab == 0 {
                            if medicineInfo.filter({ $0.isUsing == true }).isEmpty {
                                Text("使用中のお薬はありません")
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
                        
                        if selectedTab == 1 {
                            // 不使用リスト
                            if medicineInfo.filter({ $0.isUsing == false }).isEmpty {
                                Text("不使用のお薬はありません")
                                    .foregroundColor(.gray)
                            } else {
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
                .scrollBounceBehavior(.basedOnSize)
                //            .navigationTitle("お薬リスト")
                //            .toolbarTitleDisplayMode(.inlineLarge)
                .toolbarBackground(Color.gray.opacity(0.05), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("お薬リスト")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: MedicineInfoView(medicine: MedicineInfo())) {
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundColor(.blue)
                                .font(.system(size: 13))
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.15))
                                        .frame(width: 30, height: 30)
                                )
                                .padding(.horizontal, 5)
                        }
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
                .shadow(color: .gray, radius: 1.7, x: 1.5, y: 1.5)
            content()
        }
    }
}
