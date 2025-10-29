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
        VStack {
            //使用中リスト
            VStack {
                ForEach(medicineInfo.filter({ $0.isUsing == true }), id: \.id) { list in
                    Text(list.medicineName)
                }
            }
            
            //不使用リスト
            VStack {
                ForEach(medicineInfo.filter({ $0.isUsing == false }), id: \.id) { list in
                    Text(list.medicineName)
                }
            }
        }
    }
}

#Preview {
    MedicineListView()
}
