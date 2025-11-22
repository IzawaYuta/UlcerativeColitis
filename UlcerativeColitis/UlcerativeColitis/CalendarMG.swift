//
//  CalendarMG.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/18.
//

import Foundation

struct CalendarDates: Identifiable {
    var id = UUID()
    var date: Date?
}


extension Calendar {
    /// 今月の開始日を取得する
    /// - Parameter date: 対象日
    /// - Returns: 開始日
    func startOfMonth(for date:Date) -> Date? {
        let comps = dateComponents([.month, .year], from: date)
        return self.date(from: comps)
    }
    
    /// 今月の日数を取得する
    /// - Parameter date: 対象日
    /// - Returns: 日数
    func daysInMonth(for date:Date) -> Int? {
        return range(of: .day, in: .month, for: date)?.count
    }
    
    /// 今月の週数を取得する
    /// - Parameter date: 対象日
    /// - Returns: 週数
    func weeksInMonth(for date:Date) -> Int? {
        return range(of: .weekOfMonth, in: .month, for: date)?.count
    }
    
    func year(for date: Date) -> Int? {
        let comps = dateComponents([.year], from: date)
        return comps.year
    }
    
    func month(for date: Date) -> Int? {
        let comps = dateComponents([.month], from: date)
        return comps.month
    }
    
    func day(for date: Date) -> Int? {
        let comps = dateComponents([.day], from: date)
        return comps.day
    }
    
    func weekday(for date: Date) -> Int? {
        let comps = dateComponents([.weekday], from: date)
        return comps.weekday
    }
}

/// カレンダー表示用の日付配列を取得
/// - Parameter date: カレンダー表示の対象日
/// - Returns: 日付配列（常に42要素）
func createCalendarDates(_ date: Date) -> [CalendarDates] {
    var days = [CalendarDates]()
    
    // 今月の開始日
    guard let startOfMonth = Calendar.current.startOfMonth(for: date),
          let daysInMonth = Calendar.current.daysInMonth(for: date) else {
        return []
    }
    
    // 今月の全ての日付
    for day in 0..<daysInMonth {
        if let dayDate = Calendar.current.date(byAdding: .day, value: day, to: startOfMonth) {
            days.append(CalendarDates(date: dayDate))
        }
    }
    
    guard let firstDay = days.first, let lastDay = days.last,
          let firstDate = firstDay.date, let lastDate = lastDay.date,
          let firstDateWeekday = Calendar.current.weekday(for: firstDate),
          let lastDateWeekday = Calendar.current.weekday(for: lastDate) else {
        return days
    }
    
    // 初週のオフセット日数
    let firstWeekEmptyDays = firstDateWeekday - 1
    // 最終週のオフセット日数
    let lastWeekEmptyDays = 7 - lastDateWeekday
    
    // 初週のオフセットを前月の日付で埋める
    if firstWeekEmptyDays > 0 {
        for i in (1...firstWeekEmptyDays).reversed() {
            if let previousMonthDate = Calendar.current.date(byAdding: .day, value: -i, to: startOfMonth) {
                days.insert(CalendarDates(date: previousMonthDate), at: 0)
            }
        }
    }
    
    // 最終週のオフセットを翌月の日付で埋める
    if lastWeekEmptyDays > 0 {
        for i in 1...lastWeekEmptyDays {
            if let nextMonthDate = Calendar.current.date(byAdding: .day, value: i, to: lastDate) {
                days.append(CalendarDates(date: nextMonthDate))
            }
        }
    }
    
    // 42セル（7列×6行）に満たない場合、翌月の日付で埋める
    let totalCells = 42
    if days.count < totalCells {
        let remainingCells = totalCells - days.count
        if let lastDate = days.last?.date {
            for i in 1...remainingCells {
                if let nextDate = Calendar.current.date(byAdding: .day, value: i, to: lastDate) {
                    days.append(CalendarDates(date: nextDate))
                }
            }
        }
    }
    
    return days
}
