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
        let selectedDate = Calendar.current.startOfDay(for: selectDay)
        
        try! realm.write {
            if let existingDayRecord = realm.objects(DayRecord.self)
                .first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
                
                let schedule = Schedule()
                schedule.id = UUID().uuidString
                schedule.title = title
                schedule.date = selectedDate.addingTimeInterval(date.timeIntervalSince(Calendar.current.startOfDay(for: date)))
                
                existingDayRecord.schedule.append(schedule)
                
            } else {
                let newDayRecord = DayRecord()
                newDayRecord.date = selectedDate
                
                let schedule = Schedule()
                schedule.id = UUID().uuidString
                schedule.title = title
                schedule.date = selectedDate.addingTimeInterval(date.timeIntervalSince(Calendar.current.startOfDay(for: date)))
                
                newDayRecord.schedule.append(schedule)
                realm.add(newDayRecord)
            }
        }
    }
}

#Preview {
    AddSchedule(selectDay: .constant(Date()))
}
