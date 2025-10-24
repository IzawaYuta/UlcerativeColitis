//
//  StoolRecordList.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/24.
//

import SwiftUI
import RealmSwift

struct StoolRecordList: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @Binding var selectDay: Date
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        let day = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }
        
        if let day = day {
            List {
                ForEach(day.stoolRecord, id: \.self) { stool in
                    HStack {
//                        Text(dateFormatter.string(from: day.date))       // 日付（DayRecord）
                        Text(dateFormatter.string(from: stool.time))     // 時刻（StoolRecord）
                        Spacer()
                        Text("\(stool.amount)")                           // 回数
                    }
                }
            }
        }
    }
}

#Preview {
    StoolRecordList(selectDay: .constant(Date()))
}
