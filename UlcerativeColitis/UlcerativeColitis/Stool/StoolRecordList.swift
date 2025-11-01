//
//  StoolRecordList.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/24.
//

import SwiftUI
import RealmSwift

struct StoolRecordList: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @Binding var selectDay: Date
    
    var showView: () -> Void
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        let day = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }
        VStack(alignment: .leading, spacing: -25) {
            if let day = day {
                List {
                    ForEach(day.stoolRecord, id: \.self) { stool in
                        HStack {
                            Text("\(stool.amount)")
                            
                            Spacer()
                            
                            if stool.type.isEmpty {
                                Text("-")
                            } else {
                                Text(stool.type.map { $0.rawValue }.joined(separator: "、"))
                            }
                            
                            Spacer()
                            
                            Text(dateFormatter.string(from: stool.time))
                        }
                        .padding(.horizontal, 7)
                    }
                    .onDelete { indexSet in
                        deleteStoolRecords(at: indexSet, in: day)
                    }
                }
            }
            Button(action: {
                showView()
            }) {
                Text("閉じる")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.gray.opacity(0.4))
                    )
            }
            .padding(.horizontal)
        }
        .scrollContentBackground(.hidden)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
    
    private func deleteStoolRecords(at offsets: IndexSet, in day: DayRecord) {
        let realm = try! Realm()
        
        guard let thawedDay = day.thaw() else { return }
        
        try! realm.write {
            let itemsToDelete = offsets.map { thawedDay.stoolRecord[$0] }
            realm.delete(itemsToDelete)
            
            // 削除後に amount を再設定
            for (index, stool) in thawedDay.stoolRecord.enumerated() {
                stool.amount = index + 1
            }
        }
    }
}

#Preview {
    StoolRecordList(selectDay: .constant(Date()), showView: {})
}
