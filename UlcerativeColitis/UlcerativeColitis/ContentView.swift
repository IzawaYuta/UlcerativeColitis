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
    
    var body: some View {
        CalendarView(selectedYear: $selectedYear, selectedMonth: $selectedMonth, selectedDate: $selectedDate)
        RecordView(selectedYear: selectedYear, selectedMonth: selectedMonth, selectedDate: selectedDate)
    }
}
#Preview {
    ContentView()
}
