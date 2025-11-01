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
                HStack {
                    CustomShadow() {
                        Button(action: {
                            showAddScheduleView.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .font(.system(size: 13))
                        }
                        .sheet(isPresented: $showAddScheduleView) {
                            AddSchedule(selectDay: $selectDay, cancelButton: {
                                showAddScheduleView = false
                            }, doneButton: {
                                showAddScheduleView = false
                            })
                            .presentationDetents([.height(470)])
                            .presentationCornerRadius(30)
                        }
                    }
                    .frame(width: 30, height: 30)
                    
                    Text("通院予定")
                        .font(.system(size: 15))
                        
                }
                
                if let day = day {
                    List {
                        ForEach(day.schedule, id: \.self) { list in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(list.title)
                                    .font(.system(size: 17))
                                
                                if list.allDate {
                                    Text("終日")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13))
                                } else if let startDate = list.startDate,
                                          let endDate = list.endDate  {
                                    HStack {
                                        Text(startDate, style: .time)
                                        Text("-")
                                        Text(endDate, style: .time)
                                    }
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.inset)
                    .frame(width: 190, height: 100)
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
