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
    
    @State private var dosageTextField: [String: String] = [:]
    @State private var isSelected = false
    @State private var selectedMedicine = Set<String>()
    
    var body: some View {
        List {
            ForEach(medicineInfo, id: \.id) { medicine in
                HStack {
                    Image(systemName:
                            selectedMedicine.contains(medicine.id)
                          ? "checkmark.circle"
                          : "circle"
                    )
                    
                    Text(medicine.medicineName)
                    
                    Spacer()
                    
                    if let dosage = medicine.dosage {
                        TextField(
                            "",
                            text: Binding(
                                get: { dosageTextField[medicine.id] ?? "\(medicine.dosage ?? 0)" },
                                set: { dosageTextField[medicine.id] = $0 }
                            )
                        )
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                        .multilineTextAlignment(.trailing)
                        Text(medicine.unit?.customUnitName ?? medicine.unit?.unitName?.japaneseText ?? UnitArrayEnum.tablet.japaneseText)
                            .foregroundColor(.black)
                    } else {
                        Text("-")
                            .foregroundColor(.secondary)
                        Text(medicine.unit?.customUnitName ?? medicine.unit?.unitName?.japaneseText ?? UnitArrayEnum.tablet.japaneseText)
                            .foregroundColor(.secondary)
                    }
                }
                .onTapGesture {
                    isSelected.toggle()
                    if selectedMedicine.contains(medicine.id) {
                        selectedMedicine.remove(medicine.id)
                    } else {
                        selectedMedicine.insert(medicine.id)
                    }
                    print(selectedMedicine)
                }
            }
        }
    }
}

#Preview {
    AddTakingMedicineListView()
}
