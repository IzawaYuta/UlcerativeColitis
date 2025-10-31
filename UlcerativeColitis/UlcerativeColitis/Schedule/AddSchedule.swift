//
//  AddSchedule.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/30.
//

import SwiftUI
import RealmSwift

struct AddSchedule: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
        
    @Binding var selectDay: Date
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        VStack {
            Button(action: {
                saveSchedule(selectDay: selectDay)
            }) {
                Text("保存")
            }
            TextField("", text: $title)
                .textFieldStyle(.roundedBorder)
            DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
        }
    }
    
    private func saveSchedule(selectDay: Date) {
        let realm = try! Realm()
        
        // selectDay の「日付部分」と date の「時刻部分」を合成
        let dayStart = Calendar.current.startOfDay(for: selectDay)
        let timeOffset = date.timeIntervalSince(Calendar.current.startOfDay(for: date))
        let combinedDate = dayStart.addingTimeInterval(timeOffset)
        
        try! realm.write {
            // 既存のDayRecordがあるか
            if let existingDayRecord = realm.objects(DayRecord.self)
                .first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }) {
                
                // DayRecordの日付も selectDay に揃える
                existingDayRecord.date = combinedDate
                
                let schedule = Schedule()
                schedule.id = UUID().uuidString
                schedule.title = title
                schedule.date = combinedDate
                
                existingDayRecord.schedule.append(schedule)
                print("追加:", schedule)
                
            } else {
                // 新規DayRecord作成
                let newDayRecord = DayRecord()
                newDayRecord.date = combinedDate
                
                let schedule = Schedule()
                schedule.id = UUID().uuidString
                schedule.title = title
                schedule.date = combinedDate
                
                newDayRecord.schedule.append(schedule)
                realm.add(newDayRecord)
                print("新規作成:", newDayRecord)
            }
        }
    }
}

#Preview {
    AddSchedule(selectDay: .constant(Date()))
}
