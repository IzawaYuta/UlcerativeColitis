//
//  TimingPickerView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/02.
//

import SwiftUI
import RealmSwift

struct TimingPickerView: View {
    
    @Binding var timing: SecondTiming
    
    var cancel: () -> Void
    var done: () -> Void
    
    var body: some View {
        VStack {
            Picker("", selection: $timing) {
                ForEach([SecondTiming.justBeforeMeals, .beforeMeals,
                         .immediatelyAfterMeals, .afterMeals,
                         .betweenMeals, .customDefault], id: \.self) { timing in
                             Text(timing.japaneseText)
                         }
            }
            .pickerStyle(.wheel)
            .padding(.vertical)
            
            VStack(spacing: 15) {
                Text("保存")
                    .frame(width: 220, height: 30)
                    .foregroundColor(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        done()
                    }
                
                Button("キャンセル", role: .cancel) {
                    cancel()
                }
                .foregroundColor(.black)
                .font(.system(size: 15))
            }
        }
        .padding()
    }
}

#Preview {
    TimingPickerView(timing: .constant(.beforeMeals), cancel: {}, done: {})
}
