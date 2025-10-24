//
//  AddStoolRecord.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/24.
//

import SwiftUI
import RealmSwift

struct AddStoolRecord: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @State private var count: Int = 0
    @State private var selectedType: [StoolType] = []
    @State private var selectedNormal = false
    @State private var selectedSoft = false
    @State private var selectedDiarrhea = false
    @State private var selectedBlood = false
    
    @Binding var selectDay: Date
    
    var body: some View {
        VStack {
            Button(action: {
                count += 1
                addStoolRecord(selectDay: selectDay, count: count)
            }) {
                Image(systemName: "plus")
            }
            HStack {
                Button(action: {
                    selectedNormal.toggle()
                    if selectedNormal {
                        selectedType.append(.normal)
                    } else {
                        selectedType.removeAll { $0 == .normal }
                    }
                }) {
                    Text("普通")
                        .foregroundColor(selectedNormal ? .black : .gray)
                }
                Button(action: {
                    selectedSoft.toggle()
                    if selectedSoft {
                        selectedType.append(.soft)
                    } else {
                        selectedType.removeAll { $0 == .soft }
                    }
                }) {
                    Text("軟便")
                        .foregroundColor(selectedSoft ? .black : .gray)
                }
                Button(action: {
                    selectedDiarrhea.toggle()
                    if selectedDiarrhea {
                        selectedType.append(.diarrhea)
                    } else {
                        selectedType.removeAll { $0 == .diarrhea }
                    }
                }) {
                    Text("下痢")
                        .foregroundColor(selectedDiarrhea ? .black : .gray)
                }
                Button(action: {
                    selectedBlood.toggle()
                    if selectedBlood {
                        selectedType.append(.blood)
                    } else {
                        selectedType.removeAll { $0 == .blood }
                    }
                }) {
                    Text("血便")
                        .foregroundColor(selectedBlood ? .black : .gray)
                }
            }
        }
    }
    
    //追加メソッド
    private func addStoolRecord(selectDay: Date, count: Int) {
        let realm = try! Realm()
        let startOfDay = Calendar.current.startOfDay(for: selectDay)
        
        let now = Date()
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        
        // 選択した日付 + 現在時刻 を合成
        guard let combinedDate = Calendar.current.date(bySettingHour: timeComponents.hour ?? 0,
                                                       minute: timeComponents.minute ?? 0,
                                                       second: timeComponents.second ?? 0,
                                                       of: selectDay)
        else { return }
        
        
        try! realm.write {
            // 既存のDayRecordがあるか検索
            if let existingDayRecord = realm.objects(DayRecord.self)
                .filter("date == %@", startOfDay)
                .first {
                
                let stool = StoolRecord()
                stool.id = UUID().uuidString
                stool.time = combinedDate
                stool.amount = count
                stool.type.append(objectsIn: selectedType)
                
                existingDayRecord.stoolRecord.append(stool)
            } else {
                // まだ無ければ新規作成
                let newDayRecord = DayRecord()
                newDayRecord.date = startOfDay
                
                let stool = StoolRecord()
                stool.id = UUID().uuidString
                stool.time = combinedDate
                stool.amount = count
                stool.type.append(objectsIn: selectedType)
                
                newDayRecord.stoolRecord.append(stool)
                realm.add(newDayRecord)
            }
        }
    }
}

#Preview {
    AddStoolRecord(selectDay: .constant(Date()))
}
