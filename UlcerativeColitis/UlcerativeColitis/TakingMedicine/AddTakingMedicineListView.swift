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
    @State private var selectedMedicine = Set<String>()

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
                        Image(systemName: isSelected(medicine) ? "checkmark.circle" : "circle")
                        
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
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: medicine)
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
                guard let selectedInfo = medicineInfo.first(where: { $0.id == medicineId }) else { continue }
                let medicine = TakingMedicine()
                medicine.medicineName = selectedInfo.medicineName
                if let text = dosageTextField[medicine.medicineName], let value = Int(text) {
                    medicine.dosage = value
                } else {
                    medicine.dosage = nil
                }
                dayModel.takingMedicine.append(medicine)
            }
        }
    }
    
    /// 薬が選択されているかチェック
    private func isSelected(_ medicine: MedicineInfo) -> Bool {
        selectedMedicine.contains(medicine.id)
    }
    
    /// 薬の選択/解除を切り替え
    private func toggleSelection(for medicine: MedicineInfo) {
        if selectedMedicine.contains(medicine.id) {
            selectedMedicine.remove(medicine.id)
        } else {
            selectedMedicine.insert(medicine.id)
        }
        print("選択された薬のID: \(selectedMedicine)")
    }
}

#Preview {
    AddTakingMedicineListView(selectDay: .constant(Date()), addButton: {})
}
