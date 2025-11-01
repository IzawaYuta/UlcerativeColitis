//
//  AddSchedule.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/30.
//

import SwiftUI
import RealmSwift

struct AddSchedule: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @Binding var selectDay: Date
    
    @State private var title: String = ""
    @State private var allDate: Bool = false
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var memo: String = ""
    
    var cancelButton: () -> Void
    var doneButton: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Divider()
                TextField("タイトル", text: $title)
                    .frame(/*width: 380, */height: 35)
                    .padding(.horizontal, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(/*width: 390, */height: 35)
                    )
                    .padding(.horizontal, 5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .frame(/*width: 390, */height: 160)
                    VStack(spacing: 20) {
                        Toggle(" 終日", isOn: $allDate)
                        DatePicker(" 開始", selection: $startDate, displayedComponents: .hourAndMinute)
                            .disabled(allDate == true)
                            .opacity(allDate ? 0.5 : 1.0)
                        DatePicker(" 終了", selection: $endDate, displayedComponents: .hourAndMinute)
                            .disabled(allDate == true)
                            .opacity(allDate ? 0.5 : 1.0)
                            .onChange(of: startDate) { newStart in
                                endDate = Calendar.current.date(byAdding: .hour, value: 1, to: newStart) ?? newStart
                            }
                    }
                    .padding(.horizontal, 5)
                }
//                .frame(width: 380)
                .padding(.horizontal, 5)
                
                ZStack(alignment: .topLeading) {
                    // プレースホルダー
                    if memo.isEmpty {
                        Text("メモ")
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $memo)
                        .frame(/*width: 380, */height: 150)
                        .padding(4)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 5)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 35)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        cancelButton()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 5)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        doneButton()
                        saveSchedule(selectDay: selectDay)
                    }) {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 5)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("通院予定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveSchedule(selectDay: Date) {
        let realm = try! Realm()
        let calendar = Calendar.current
        
        // selectDay の日付部分（00:00）
        let dayStart = calendar.startOfDay(for: selectDay)
        
        // startDate / endDate の時間部分だけを抽出
        let startComponents = calendar.dateComponents([.hour, .minute, .second], from: startDate)
        let endComponents = calendar.dateComponents([.hour, .minute, .second], from: endDate)
        
        // selectDayの日付 + 時間部分で合成
        let combinedStartDate = calendar.date(bySettingHour: startComponents.hour ?? 0,
                                              minute: startComponents.minute ?? 0,
                                              second: startComponents.second ?? 0,
                                              of: dayStart) ?? startDate
        let combinedEndDate = calendar.date(bySettingHour: endComponents.hour ?? 0,
                                            minute: endComponents.minute ?? 0,
                                            second: endComponents.second ?? 0,
                                            of: dayStart) ?? endDate
        
        try! realm.write {
            // 既存のDayRecordを取得 or 新規作成
            let existingDayRecord = realm.objects(DayRecord.self)
                .first(where: { calendar.isDate($0.date, inSameDayAs: selectDay) })
            
            if let dayRecord = existingDayRecord {
                // DayRecordの日付を selectDay に揃える
                dayRecord.date = dayStart
                
                let schedule = Schedule()
                schedule.id = UUID().uuidString
                schedule.title = title
                schedule.allDate = allDate
                if !allDate {
                    schedule.startDate = combinedStartDate
                    schedule.endDate = combinedEndDate
                }
                schedule.memo = memo
                
                dayRecord.schedule.append(schedule)
                print("追加:", schedule)
                
            } else {
                // 新規DayRecord作成
                let newDayRecord = DayRecord()
                newDayRecord.date = dayStart
                
                let schedule = Schedule()
                schedule.id = UUID().uuidString
                schedule.title = title
                schedule.allDate = allDate
                if !allDate {
                    schedule.startDate = combinedStartDate
                    schedule.endDate = combinedEndDate
                }
                schedule.memo = memo
                
                newDayRecord.schedule.append(schedule)
                realm.add(newDayRecord)
                print("新規作成:", newDayRecord)
            }
        }
    }
}

#Preview {
    AddSchedule(selectDay: .constant(Date()), cancelButton: {}, doneButton: {})
}
