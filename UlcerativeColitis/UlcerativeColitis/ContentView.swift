//
//  ContentView.swift
//  Test
//
//  Created by Engineer MacBook Air on 2025/10/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedYear: Date? = Date()
    @State private var selectedMonth: Date? = Date()
    @State private var selectedDate: Date? = Date()
    @State private var selectDay: Date = Date()
    
    var body: some View {
        CalendarView(selectedYear: $selectedYear, selectedMonth: $selectedMonth, selectedDate: $selectedDate, selectDay: $selectDay)
        HStack {
            RecordView(selectedYear: selectedYear, selectedMonth: selectedMonth, selectedDate: selectedDate, selectDay: $selectDay)
            ScheduleView(selectDay: $selectDay)
        }
    }
}
#Preview {
    ContentView()
}
