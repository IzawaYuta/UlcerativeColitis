//
//  CalendarView.swift
//  Test
//
//  Created by Engineer MacBook Air on 2025/10/17.
//

import SwiftUI
import RealmSwift

struct CalendarView: View {
    
    @ObservedResults(DayRecord.self) var dayRecord
    @ObservedResults(Schedule.self) var schedule
    
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())
    
    @State private var showDatePicker = false
    @State private var yearDate: Int = Calendar.current.component(.year, from: Date())
    @State private var monthDate: Int = Calendar.current.component(.month, from: Date())
    
    @Binding var selectedYear: Date?
    @Binding var selectedMonth: Date?
    @Binding var selectedDate: Date?
    
    @State private var selectedDay: Date = Date() //選択中の日付
    @Binding var selectDay: Date //配布用日付
    @State private var isSelected = false //初期は選択しない
    
    private let model = CalendarModel()
    private let weekdays = ["日", "月", "火", "水", "木", "金", "土"]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var body: some View {
        let dates = model.dates(forYear: year, month: month)
        let firstWeekday = model.firstWeekday(forYear: year, month: month)
        
        VStack {
            // 年月表示と切り替えボタン
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Button(action: {
                    showDatePicker = true
                }) {
                    Text("\(String(year))年\(month)月")
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                        .padding(.horizontal, 5)
                }
                .sheet(isPresented: $showDatePicker) {
                    VStack {
                        HStack {
                            Button("キャンセル", role: .cancel) {
                                showDatePicker = false
                            }
                            .foregroundColor(.black)
                            Spacer()
                            Button(action: {
                                showDatePicker = false
                                year = yearDate
                                month = monthDate
                            }) {
                                Text("完了")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 5) {
                            YearPicker(yearPicker: $yearDate,
                                       doneButton: {},
                                       cancelButton: {}
                            )
                            MonthPicker(monthPicker: $monthDate,
                                        doneButton: {},
                                        cancelButton: {}
                            )
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .presentationDetents([.height(200)])
                    .interactiveDismissDisabled(true)
                }
                
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    let today = Date()
                    let calendar = Calendar.current
                    year = calendar.component(.year, from: today)
                    month = calendar.component(.month, from: today)
                    selectedDay = today
                    selectDay = today
                    isSelected = true
                }) {
                    Text("今日")
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // 曜日ヘッダー
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "日" ? .red : (day == "土" ? .blue : .primary))
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            
            // 日付グリッド
            let totalCells = 42
            let emptyCellsBefore = Array(repeating: "", count: firstWeekday - 1)
            let dateStrings = dates.map { model.formatter.string(from: $0) }
            let emptyCellsAfter = Array(repeating: "", count: totalCells - emptyCellsBefore.count - dateStrings.count)
            
            let allDays = emptyCellsBefore + dateStrings + emptyCellsAfter
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {
                ForEach(allDays.indices, id: \.self) { index in
                    let text = allDays[index]
                    let dayInt = Int(text) ?? -1
                    let cellDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt))
                    let cellDayRecord = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: cellDate ?? Date()) }
                    ZStack(alignment: .center) {
                        // 選択中の日付なら青く塗る
                        if (isToday(day: dayInt)) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        } else if isSelected, let cellDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt)),
                                  Calendar.current.isDate(cellDate, inSameDayAs: selectedDay) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.orange, lineWidth: 2)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                        }
                        
                        VStack(spacing: 5) {
                            Text(text)
                                .font(.system(size: 15))
                                .bold()
                            if let cellDayRecord = cellDayRecord, !cellDayRecord.schedule.isEmpty {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 5, height: 5)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                    .onTapGesture {
                        guard dayInt != -1 else { return }
                        if let newDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt)) {
                            selectedDay = newDate
                            selectDay = newDate
                            isSelected = true
                        }
                        // 選択日付を設定
                        selectedYear = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt))
                        selectedMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt))
                        selectedDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt))
                    }
                }
            }
            .padding(.horizontal, 8)
            
            Text(dateFormatter.string(from: selectedDay))
            
            Spacer()
        }
    }
    
    private func changeMonth(_ offset: Int) {
        var date = Calendar.current.date(from: DateComponents(year: year, month: month))!
        date = Calendar.current.date(byAdding: .month, value: offset, to: date)!
        year = Calendar.current.component(.year, from: date)
        month = Calendar.current.component(.month, from: date)
    }
    
    private func isToday(day dayInt: Int) -> Bool {
        let today = Calendar.current
        let currentYear = today.component(.year, from: Date())
        let currentMonth = today.component(.month, from: Date())
        let currentDay = today.component(.day, from: Date())
        
        return year == currentYear && month == currentMonth && dayInt == currentDay
    }
}

#Preview {
    CalendarView(selectedYear: .constant(Date()), selectedMonth: .constant(Date()), selectedDate: .constant(Date()), selectDay: .constant(Date()))
}
