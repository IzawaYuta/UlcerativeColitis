//
//  RecordView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/18.
//

import SwiftUI
import RealmSwift

struct RecordView: View {
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    // 親ビューから渡される選択済み日付
    let selectedYear: Date?
    let selectedMonth: Date?
    let selectedDate: Date?
    
    @Binding var selectDay: Date
    
    @State private var count: Int = 0
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack {
//                        if let year = selectedYear {
//            Text("選択日: \(year.formatted(.dateTime.year()))")
//                .font(.title2)
//        }
//            
//            if let month = selectedMonth {
//                Text("選択日: \(month.formatted(.dateTime.month()))")
//                    .font(.title2)
//            }
//
//            if let date = selectedDate {
//                Text("選択日: \(date.formatted(.dateTime.day()))")
//                    .font(.title2)
//            }

//            } else {
//                Text("日付を選択してください")
//                    .font(.title2)
//            }
            
                Text("選択日: \(selectDay.formatted(.dateTime.year().month().day()))")
            
            
                Button(action: {
                    count += 1
                    addStoolRecord(selectDay: selectDay, count: count)
                }) {
                    Image(systemName: "plus")
                }
                
                        let day = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }

            if let day = day {
                List {
                    ForEach(day.stoolRecord, id: \.self) { stool in
                        HStack {
                            Text(dateFormatter.string(from: day.date))       // 日付（DayRecord）
                            Text(dateFormatter.string(from: stool.time))     // 時刻（StoolRecord）
                            Text("\(stool.amount)")                           // 回数
                        }
                    }
                }
            }
            
            ZStack {
                CustomBackground()
                VStack {
                    HStack {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        }
                        Button(action: {
                            
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.black)
                        }
                    }
                    Text("\(stoolRecords.filter{Calendar.current.isDate($0.time, inSameDayAs: selectDay)}.count)")
                }
            }
        }
        .padding()
    }
    
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
                stool.type = .normal
                
                existingDayRecord.stoolRecord.append(stool)
            } else {
                // まだ無ければ新規作成
                let newDayRecord = DayRecord()
                newDayRecord.date = startOfDay
                
                let stool = StoolRecord()
                stool.id = UUID().uuidString
                stool.time = combinedDate
                stool.amount = count
                stool.type = .normal
                
                newDayRecord.stoolRecord.append(stool)
                realm.add(newDayRecord)
            }
        }
    }
}

#Preview {
    RecordView(selectedYear: Date(), selectedMonth: Date(), selectedDate: Date(), selectDay: .constant(Date()))
}
