//
//  CalendarView2.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/18.
//

import SwiftUI

struct CalendarView2: View {
    @State private var currentDate = Date() // @Stateに変更
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating = false
    
    @State private var selectedDate: Date? = Date()
    
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
    
    private var calendarDates: [CalendarDates] {
        createCalendarDates(currentDate)
    }

    var body: some View {
        
        VStack(spacing: 50) {
            if let selected = selectedDate {
                Text("選択: \(formatDate(selected))")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }

            HStack {
                Button(action: {
                    changeMonth(-1)
                }) {
                    Image(systemName: "plus")
                }
                // yyyy/MM
                Text(String(format: "%04d/%02d", year, month))
                    .font(.system(size: 24))
                Button(action: {
                    changeMonth(1)
                }) {
                    Image(systemName: "plus")
                }
            }
            
            // 曜日
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday).frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(weekday == "日" ? .red : (weekday == "土" ? .blue : .black))
                }
            }
            

            
            // カレンダー
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(calendarDates) { calendarDates in
                    if let date = calendarDates.date, let day = Calendar.current.day(for: date),
                        let day = Calendar.current.day(for: date),
                       let weekday = Calendar.current.weekday(for: date) {
                        
                        let isCurrentMonth = Calendar.current.month(for: date) == Calendar.current.month(for: currentDate)
                        let isSelected = selectedDate != nil && Calendar.current.isDate(date, inSameDayAs: selectedDate!)
                        
                        // ---- 土日色のロジック ----
                        let textColor: Color = {
                            if isSelected { return .white }
                            
                            if isCurrentMonth {
                                if weekday == 1 { return .red }   // 日曜
                                if weekday == 7 { return .blue }  // 土曜
                                return .black                     // 平日
                            } else {
                                return .gray                      // 他の月は土日も gray
                            }
                        }()
                        // --------------------------
                        


                        
                        Text("\(day)")
                            .frame(width: 40, height: 40)
                            .background(isSelected ? Color.blue : Color.clear)
                            .foregroundColor(textColor)
                            .opacity(isCurrentMonth || isSelected ? 1.0 : 0.4)
                            .cornerRadius(20)
                            .onTapGesture {
                                selectedDate = date
                                print("選択された日付: \(formatDate(date))")
                            }
                    } else {
                        Text("")
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .frame(height: 240) // 6行 × 40px = 240px固定
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isAnimating {
                            dragOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        
                        if horizontalAmount < -50 {
                            // 左スワイプ → 次の月へ
                            withAnimation(.easeOut(duration: 0.3)) {
                                dragOffset = -400
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                changeMonth(1)
                                dragOffset = 400
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    dragOffset = 0
                                    isAnimating = false
                                }
                            }
                        } else if horizontalAmount > 50 {
                            // 右スワイプ → 前の月へ
                            withAnimation(.easeOut(duration: 0.3)) {
                                dragOffset = 400
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                changeMonth(-1)
                                dragOffset = -400
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    dragOffset = 0
                                    isAnimating = false
                                }
                            }
                        } else {
                            // スワイプ距離が足りない場合は元に戻す
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .frame(width: 400, alignment: .center)
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
    CalendarView2()
}
