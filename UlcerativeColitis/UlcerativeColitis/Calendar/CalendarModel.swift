//
//  Model.swift
//  Test
//
//  Created by Engineer MacBook Air on 2025/10/16.
//

import Foundation

import SwiftUI

class CalendarModel {
    let calendar = Calendar.current
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "d" // 日だけ
        return f
    }()
    
    // 指定した年月の全日付を返す
    func dates(forYear year: Int, month: Int) -> [Date] {
        guard let baseDate = calendar.date(from: DateComponents(year: year, month: month)),
              let range = calendar.range(of: .day, in: .month, for: baseDate) else {
            return []
        }
        
        return range.compactMap { day -> Date? in
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            return calendar.date(from: components)
        }
    }
    
    // 月の最初の曜日を取得（1=日, 7=土）
    func firstWeekday(forYear year: Int, month: Int) -> Int {
        let firstDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        return calendar.component(.weekday, from: firstDate)
    }
}
