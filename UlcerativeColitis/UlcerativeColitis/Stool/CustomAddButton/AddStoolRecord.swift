//
//  AddStoolRecord.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/24.
//

import SwiftUI
import RealmSwift

struct AddStoolRecord: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @State private var count: Int = 0
    @State private var selectedType: [StoolType] = []
    @State private var selectedNormal = false
    @State private var selectedHard = false
    @State private var selectedSoft = false
    @State private var selectedDiarrhea = false
    @State private var selectedConstipation = false
    @State private var selectedBlood = false
    
    @Binding var selectDay: Date
    
    var showView: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                HStack(spacing: 17) {
                    CustomAddButtonView(isPresented: selectedNormal, action: {
                        selectedNormal.toggle()
                        if selectedNormal {
                            selectedType.append(.normal)
                        } else {
                            selectedType.removeAll { $0 == .normal }
                        }
                    }) {
                        Text("普通")
                    }
                    .frame(width: 70, height: 50)
                    
                    CustomAddButtonView(isPresented: selectedHard, action: {
                        selectedHard.toggle()
                        if selectedHard {
                            selectedType.append(.hard)
                        } else {
                            selectedType.removeAll { $0 == .hard }
                        }
                    }) {
                        Text("硬便")
                    }
                    .frame(width: 70, height: 50)
                    
                    CustomAddButtonView(isPresented: selectedSoft, action: {
                        selectedSoft.toggle()
                        if selectedSoft {
                            selectedType.append(.soft)
                        } else {
                            selectedType.removeAll { $0 == .soft }
                        }
                    }) {
                        Text("軟便")
                    }
                    .frame(width: 70, height: 50)
                }
                
                HStack(spacing: 17) {
                    CustomAddButtonView(isPresented: selectedDiarrhea, action: {
                        selectedDiarrhea.toggle()
                        if selectedDiarrhea {
                            selectedType.append(.diarrhea)
                        } else {
                            selectedType.removeAll { $0 == .diarrhea }
                        }
                    }) {
                        Text("下痢")
                    }
                    .frame(width: 70, height: 50)
                    
                    CustomAddButtonView(isPresented: selectedConstipation, action: {
                        selectedConstipation.toggle()
                        if selectedConstipation {
                            selectedType.append(.constipation)
                        } else {
                            selectedType.removeAll { $0 == .constipation }
                        }
                    }) {
                        Text("便秘")
                    }
                    .frame(width: 70, height: 50)
                    
                    CustomAddButtonView(isPresented: selectedBlood, action: {
                        selectedBlood.toggle()
                        if selectedBlood {
                            selectedType.append(.blood)
                        } else {
                            selectedType.removeAll { $0 == .blood }
                        }
                    }) {
                        Text("血便")
                    }
                    .frame(width: 70, height: 50)
                }
                
            }
            Button(action: {
                count += 1
                addStoolRecord(selectDay: selectDay)
                showView()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 200, height: 50)
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
    }
    
    //追加メソッド
    //    private func addStoolRecord(selectDay: Date, count: Int) {
    //        let realm = try! Realm()
    //        let startOfDay = Calendar.current.startOfDay(for: selectDay)
    //
    //        let now = Date()
    //        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
    //
    //        // 選択した日付 + 現在時刻 を合成
    //        guard let combinedDate = Calendar.current.date(bySettingHour: timeComponents.hour ?? 0,
    //                                                       minute: timeComponents.minute ?? 0,
    //                                                       second: timeComponents.second ?? 0,
    //                                                       of: selectDay)
    //        else { return }
    //
    //
    //        try! realm.write {
    //            // 既存のDayRecordがあるか検索
    //            if let existingDayRecord = realm.objects(DayRecord.self)
    //                .filter("date == %@", startOfDay)
    //                .first {
    //
    //                let stool = StoolRecord()
    //                stool.id = UUID().uuidString
    //                stool.time = combinedDate
    //                stool.amount = count
    //                stool.type.append(objectsIn: selectedType)
    //
    //                existingDayRecord.stoolRecord.append(stool)
    //            } else {
    //                // まだ無ければ新規作成
    //                let newDayRecord = DayRecord()
    //                newDayRecord.date = startOfDay
    //
    //                let stool = StoolRecord()
    //                stool.id = UUID().uuidString
    //                stool.time = combinedDate
    //                stool.amount = count
    //                stool.type.append(objectsIn: selectedType)
    //
    //                newDayRecord.stoolRecord.append(stool)
    //                realm.add(newDayRecord)
    //            }
    //        }
    //    }
    private func addStoolRecord(selectDay: Date) {
        let realm = try! Realm()
        let startOfDay = Calendar.current.startOfDay(for: selectDay)
        let now = Date()
        
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        guard let combinedDate = Calendar.current.date(bySettingHour: timeComponents.hour ?? 0,
                                                       minute: timeComponents.minute ?? 0,
                                                       second: timeComponents.second ?? 0,
                                                       of: selectDay)
        else { return }
        
        try! realm.write {
            // 既存のDayRecordがあるか検索
            let dayRecord = realm.objects(DayRecord.self).filter("date == %@", startOfDay).first
            
            let stool = StoolRecord()
            stool.time = combinedDate
            stool.type.append(objectsIn: selectedType)
            
            // 連番を決める
            if let dayRecord = dayRecord {
                stool.amount = dayRecord.stoolRecord.count + 1
                dayRecord.stoolRecord.append(stool)
            } else {
                let newDayRecord = DayRecord()
                newDayRecord.date = startOfDay
                stool.amount = 1
                newDayRecord.stoolRecord.append(stool)
                realm.add(newDayRecord)
            }
        }
    }
    
}

#Preview {
    AddStoolRecord(selectDay: .constant(Date()), showView: {})
}
