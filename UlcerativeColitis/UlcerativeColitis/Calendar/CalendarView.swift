//
//  CalendarView.swift
//  Test
//
//  Created by Engineer MacBook Air on 2025/10/17.
//

import SwiftUI

struct CalendarView: View {
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())
    
    private let model = CalendarModel()
    private let weekdays = ["日", "月", "火", "水", "木", "金", "土"]
    
    var body: some View {
        let dates = model.dates(forYear: year, month: month)
        let firstWeekday = model.firstWeekday(forYear: year, month: month)
        
        VStack {
            // 年月表示と切り替えボタン
            HStack {
                Spacer()
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Text("\(String(year))年\(month)月")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 5)
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
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
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        
                        VStack(spacing: 5) {
                            let text = allDays[index]
                            Text(text)
                                .font(.system(size: 15))
                            Circle()
                                .fill(Color.red)
                                .frame(width: 5, height: 5)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
    }
    
    private func changeMonth(_ offset: Int) {
        var date = Calendar.current.date(from: DateComponents(year: year, month: month))!
        date = Calendar.current.date(byAdding: .month, value: offset, to: date)!
        year = Calendar.current.component(.year, from: date)
        month = Calendar.current.component(.month, from: date)
    }
}

#Preview {
    CalendarView()
}
