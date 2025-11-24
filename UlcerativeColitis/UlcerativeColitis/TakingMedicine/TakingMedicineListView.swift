//
//  TakingMedicineListView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/24.
//

import SwiftUI
import RealmSwift

struct TakingMedicineListView: View {
    
    @ObservedResults(DayRecord.self) var dayRecord
    @ObservedResults(TakingMedicine.self) var takingMedicine
    
    @Binding var selectDay: Date
    
    var body: some View {
        if let day = dayRecord.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }) {
            List {
                ForEach(day.takingMedicine, id: \.id) { medicine in
                    Text(medicine.medicineName)
                }
            }
        } else {
            Text("この日の記録はありません")
        }
    }
}

#Preview {
    TakingMedicineListView(selectDay: .constant(Date()))
}
