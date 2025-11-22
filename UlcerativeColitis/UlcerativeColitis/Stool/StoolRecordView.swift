//
//  StoolRecordView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/22.
//

import SwiftUI
import RealmSwift

struct StoolRecordView: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @Binding var selectDay: Date
    
    var body: some View {
        let day = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 1)
                .frame(height: 100)
            HStack(spacing: 30) {
                    Image(systemName: "text.document")
                        .foregroundColor(.blue)
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 40, height: 40)
                        )
                VStack(alignment: .trailing) {
                    Text("排便回数")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    HStack(alignment: .bottom, spacing: 5) {
                        Text("\(day?.stoolRecord.count ?? 0)")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding(.bottom, -6)
                        
                        Text("回")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 40, height: 40)
                        )
                }
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    StoolRecordView(selectDay: .constant(Date()))
        .background(Color.cyan.opacity(0.1))
}
