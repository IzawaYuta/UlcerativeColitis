//
//  MealAddRecordView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/12/20.
//

import SwiftUI

enum MealTime {
    case morning, lunch, dinner
}

struct MealAddRecordView: View {
    
    @State private var selectedMeal: MealTime? = nil
    @State private var eatTime: Date = Date()
    @State private var eatTextEditor: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Color.orange.opacity(0.2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                VStack(alignment: .leading,spacing: 30) {
                    Text("食事記録")
                    HStack(spacing: 25) {
                        CustomTimeView(
                            color: .orange,
                            text: "朝",
                            isSelected: selectedMeal == .morning
                        ) {
                            selectedMeal = .morning
                        }
                        
                        CustomTimeView(
                            color: .yellow,
                            text: "昼",
                            isSelected: selectedMeal == .lunch
                        ) {
                            selectedMeal = .lunch
                        }
                        
                        CustomTimeView(
                            color: .purple,
                            text: "夜",
                            isSelected: selectedMeal == .dinner
                        ) {
                            selectedMeal = .dinner
                        }
                    }
                }
                .padding(.horizontal)
            }
            VStack(alignment: .leading) {
                Text("食事の時間")
                DatePicker("", selection: $eatTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            VStack {
                Text("食べたもの")
                TextEditor(text: $eatTextEditor)
                    .border(Color.black)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear)
                            .border(Color.red)
                    )
            }
        }
        .padding(.horizontal)
    }
}

struct CustomTimeView: View {
    
    let color: Color
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? color.opacity(0.8) : color.opacity(0.2))
                    .frame(width: 100, height: 50)
                
                Text(text)
                    .foregroundColor(.black.opacity(isSelected ? 1.0 : 0.7))
            }
        }
    }
}

#Preview {
    MealAddRecordView()
}
