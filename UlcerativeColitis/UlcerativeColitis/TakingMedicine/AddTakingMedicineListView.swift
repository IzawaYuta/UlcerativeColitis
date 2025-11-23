//
//  AddTakingMedicineListView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/23.
//

import SwiftUI
import RealmSwift

struct AddTakingMedicineListView: View {
    
    @ObservedResults(MedicineInfo.self) var medicineInfo
    
    var body: some View {
        List {
            ForEach(medicineInfo, id: \.id) { medicine in
                Text(medicine.medicineName)
            }
        }
    }
}

#Preview {
    AddTakingMedicineListView()
}
