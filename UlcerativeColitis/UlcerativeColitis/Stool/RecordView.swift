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
    @State private var showStoolRecordList = false
    @State private var showAddStoolRecord = false
    
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
                    
                }) {
                    Image(systemName: "plus")
                }
                
            
            ZStack {
                CustomBackground()
                VStack {
                    HStack {
                        Button(action: {
                            showAddStoolRecord.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showAddStoolRecord) {
                            AddStoolRecord(selectDay: $selectDay)
                        }
                        Button(action: {
                            showStoolRecordList.toggle()
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showStoolRecordList) {
                            StoolRecordList(selectDay: $selectDay)
                        }
                    }
                    Text("\(stoolRecords.filter{Calendar.current.isDate($0.time, inSameDayAs: selectDay)}.count)")
                }
            }
        }
        .padding()
    }
    
    
}

#Preview {
    RecordView(selectedYear: Date(), selectedMonth: Date(), selectedDate: Date(), selectDay: .constant(Date()))
}
