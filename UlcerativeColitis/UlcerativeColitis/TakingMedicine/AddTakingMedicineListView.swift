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
    @ObservedResults(DayRecord.self) var dayRecord
    
    @State private var dosageTextField: [String: String] = [:]
    @State private var isSelected = false
    @State private var selectedMedicine: [String] = []
    
    @Binding var selectDay: Date
    
    var addButton: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                addTakingMedicine()
                addButton()
            }) {
                Image(systemName: "plus")
            }
            List {
                ForEach(medicineInfo, id: \.id) { medicine in
                    HStack {
                        Image(systemName:
                                selectedMedicine.contains(medicine.medicineName)
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
                        if let index = selectedMedicine.firstIndex(of: medicine.medicineName) {
                            selectedMedicine.remove(at: index)
                        } else {
                            selectedMedicine.append(medicine.medicineName)
                        }
                        print(selectedMedicine)
                    }
                }
            }
        }
    }
    
    private func addTakingMedicine() {
        let realm = try! Realm()
        
        try! realm.write {
            // 既存のDayRecordを取得
            let existingDay = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }
            
            let dayModel: DayRecord
            if let thawedDay = existingDay?.thaw() {
                dayModel = thawedDay
            } else {
                dayModel = DayRecord()
                dayModel.date = selectDay
                realm.add(dayModel)
            }
            
            // 選択された薬を追加
            for medicineId in selectedMedicine {
                let medicine = TakingMedicine()
                medicine.medicineName = medicineId
                dayModel.takingMedicine.append(medicine)
            }
        }
    }
}

#Preview {
    AddTakingMedicineListView(selectDay: .constant(Date()), addButton: {})
}
