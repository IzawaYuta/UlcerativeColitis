//
//  CalendarView2.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/18.
//

import SwiftUI

struct CalendarView2: View {
    @State private var currentDate = Date()
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating = false
    
    @Binding var selectDay: Date
    @State private var showCalendarPicker = false
    
    private var weekdays: [String] {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ja_JP")
        return cal.veryShortWeekdaySymbols
    }
    
    // グリッドアイテム
    let columns: [GridItem] = Array(repeating: .init(.fixed(40)), count: 7)
    
    // computed propertyに変更
    private var year: Int {
        Calendar.current.component(.year, from: currentDate)
    }
    
    private var month: Int {
        Calendar.current.component(.month, from: currentDate)
    }
    
    // Picker用の一時変数
    @State private var tempYear: Int = Calendar.current.component(.year, from: Date())
    @State private var tempMonth: Int = Calendar.current.component(.month, from: Date())
    
    private var calendarDates: [CalendarDates] {
        createCalendarDates(currentDate)
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(height: 370)
                VStack(alignment: .center, spacing: 5) { //年月とカレンダーのspacing
                    HStack {
                        HStack(spacing: 8) {
                            Button(action: {
                                changeMonth(-1)
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                            }
                            Text(String(format: "%04d年%02d月", year, month))
                                .font(.system(size: 24))
                                .onTapGesture {
                                    tempYear = year
                                    tempMonth = month
                                    showCalendarPicker.toggle()
                                }
                                .sheet(isPresented: $showCalendarPicker) {
                                    HStack {
                                        YearPicker(yearPicker: $tempYear, doneButton: {}, cancelButton: {})
                                        MonthPicker(monthPicker: $tempMonth, doneButton: {}, cancelButton: {})
                                        
                                        Button("完了") {
                                            if let newDate = Calendar.current.date(from: DateComponents(year: tempYear, month: tempMonth, day: 1)) {
                                                currentDate = newDate
                                            }
                                            showCalendarPicker = false
                                        }
                                        .padding()
                                    }
                                }
                            Button(action: {
                                changeMonth(1)
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Text("今日")
                            .foregroundColor(
                                Calendar.current.isDateInToday(selectDay)
                                ? .clear
                                : .blue
                            )
                            .font(.system(size: 13))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        Calendar.current.isDateInToday(selectDay)
                                        ? Color.clear : Color.blue.opacity(0.13)
                                    )
                            )
                            .onTapGesture {
                                currentDate = Date()
                                selectDay = Date()
                            }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    VStack(spacing: 15) {
                        // 曜日
                        HStack {
                            ForEach(weekdays, id: \.self) { weekday in
                                Text(weekday).frame(width: 40, height: 40, alignment: .center)
                                    .foregroundColor(weekday == "日" ? .red : (weekday == "土" ? .blue : .black))
                            }
                        }
                        
                        // カレンダー
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(calendarDates) { calendarDates in
                                if let date = calendarDates.date,
                                   let day = Calendar.current.day(for: date),
                                   let weekday = Calendar.current.weekday(for: date) {
                                    
                                    let isCurrentMonth = Calendar.current.month(for: date) == Calendar.current.month(for: currentDate)
                                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectDay)
                                    
                                    let textColor: Color = {
                                        if isSelected { return .white }
                                        
                                        if isCurrentMonth {
                                            if weekday == 1 { return .red }
                                            if weekday == 7 { return .blue }
                                            return .black
                                        } else {
                                            return .gray
                                        }
                                    }()
                                    
                                    Text("\(day)")
                                        .frame(width: 40, height: 40)
                                        .background(isSelected ? Color.blue : Color.clear)
                                        .foregroundColor(textColor)
                                        .opacity(isCurrentMonth || isSelected ? 1.0 : 0.4)
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            selectDay = date
                                            print("選択された日付: \(formatDate(date))")
                                        }
                                } else {
                                    Text("")
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                        .frame(height: 240)
                        .offset(x: dragOffset)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    // 横方向の移動距離
                                    let horizontalAmount = value.translation.width
                                    
                                    withAnimation(.none) {
                                        if horizontalAmount < -50 {
                                            // 左スワイプ → 次の月へ
                                            changeMonth(1)
                                        } else if horizontalAmount > 50 {
                                            // 右スワイプ → 前の月へ
                                            changeMonth(-1)
                                        }
                                    }
                                }
                        )
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Text("選択: \(formatDate(selectDay))")
                .font(.system(size: 16))
                .foregroundColor(.blue)
        }
    }
    
    private func changeMonth(_ offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: currentDate) {
            currentDate = newDate
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView2(selectDay: .constant(Date()))
        .background(Color.cyan.opacity(0.1))
}
