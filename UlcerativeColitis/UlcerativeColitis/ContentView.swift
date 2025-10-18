//
//  ContentView.swift
//  Test
//
//  Created by Engineer MacBook Air on 2025/10/16.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            CalendarView(selectedDate: $selectedDate)
            
            RecordView(selectedDate: selectedDate)
        }
    }
}

#Preview {
    ContentView()
}
