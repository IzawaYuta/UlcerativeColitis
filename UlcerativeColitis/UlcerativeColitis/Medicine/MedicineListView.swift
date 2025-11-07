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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 使用中リスト
                    VStack(alignment: .leading, spacing: 8) {
                        Text("使用中")
                            .font(.headline)
                        
                        if medicineInfo.filter({ $0.isUsing == true }).isEmpty {
                            Text("なし")
                                .foregroundColor(.gray)
                        } else {
                            List {
                                ForEach(medicineInfo.filter({ $0.isUsing == true }), id: \.id) { list in
                                    NavigationLink(destination: MedicineInfoView(medicine: list)) {
                                        Text(list.medicineName)
                                    }
                                }
                            }
                            .frame(height: CGFloat(medicineInfo.filter({ $0.isUsing == true }).count) * 44) // 高さ調整
                            .listStyle(.plain)
                        }
                    }
                    
                    Divider()
                    
                    // 不使用リスト
                    VStack(alignment: .leading, spacing: 8) {
                        Text("不使用")
                            .font(.headline)
                        
                        if medicineInfo.filter({ $0.isUsing == false }).isEmpty {
                            Text("なし")
                                .foregroundColor(.gray)
                        } else {
                            List {
                                ForEach(medicineInfo.filter({ $0.isUsing == false }), id: \.id) { list in
                                    NavigationLink(destination: MedicineInfoView(medicine: list)) {
                                        Text(list.medicineName)
                                    }
                                }
                            }
                            .frame(height: CGFloat(medicineInfo.filter({ $0.isUsing == false }).count) * 44)
                            .listStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("お薬リスト")
        }
    }
}

#Preview {
    MedicineListView()
}
