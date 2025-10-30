//
//  ScheduleView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/30.
//

import SwiftUI
import RealmSwift

struct ScheduleView: View {
    
    @ObservedResults(Schedule.self) var schedule
    @ObservedResults(DayRecord.self) var dayRecord
    
    @State private var showAddScheduleView = false
    
    @Binding var selectDay: Date
    
    var body: some View {
        let day = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }
        
        ZStack {
            CustomBackground()
            VStack {
                Button(action: {
                    showAddScheduleView.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showAddScheduleView) {
                    AddSchedule(selectDay: $selectDay)
                }
                
                if let day = day {
                    List {
                        ForEach(day.schedule, id: \.self) { list in
                            Text(list.title)
                        }
                    }
                    .frame(width: 100, height: 100)
                } else {
                    Text("この日の予定はありません")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    ScheduleView(selectDay: .constant(Date()))
}
