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
    @AppStorage("selectedNormal") var selectedNormal = false
    @AppStorage("selectedHard") var selectedHard = false
    @AppStorage("selectedSoft") var selectedSoft = false
    @AppStorage("selectedDiarrhea") var selectedDiarrhea = false
    @AppStorage("selectedConstipation") var selectedConstipation = false
    @AppStorage("selectedBlood") var selectedBlood = false
    @AppStorage("toggleFixed") var toggleFixed = false
    
    @Binding var selectDay: Date
    
    var showView: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Button(action: {
                toggleFixed.toggle()
            }) {
                HStack {
                    Text("選択を固定")
                    Image(systemName: toggleFixed ? "checkmark.circle" : "circle")
                }
            }
            .buttonStyle(.bordered)
            HStack(spacing: 15) {
                VStack(spacing: 17) {
                    let rgbGreen = Color(red: 210/255, green: 242/255, blue: 221/255)
                    let rgbGreen2 = Color(red: 173/255, green: 250/255, blue: 177/255)
                    let rgbBrown = Color(red: 231/255, green: 195/255, blue: 183/255)
                    let rgbBrown2 = Color(red: 191/255, green: 155/255, blue: 142/255)
                    let rgbYellow = Color(red: 254/255, green: 249/255, blue: 195/255)
                    let rgbYellow2 = Color(red: 254/255, green: 250/255, blue: 109/255)
                    CustomAddButtonView(color: rgbGreen, color2: rgbGreen2, isPresented: $selectedNormal) {
                        VStack(spacing: 13) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 30))
                            Text("普通")
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        selectedNormal.toggle()
                        if selectedNormal {
                            selectedType.append(.normal)
                        } else {
                            selectedType.removeAll { $0 == .normal }
                        }
                    }
                    
                    CustomAddButtonView(color: rgbBrown, color2: rgbBrown2, isPresented: $selectedHard) {
                        VStack(spacing: 13) {
                            Image(systemName: "square.fill")
                                .font(.system(size: 30))
                            Text("硬便")
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        selectedHard.toggle()
                        if selectedHard {
                            selectedType.append(.hard)
                        } else {
                            selectedType.removeAll { $0 == .hard }
                        }
                        
                    }
                    
                    CustomAddButtonView(color: rgbYellow, color2: rgbYellow2, isPresented: $selectedSoft) {
                        VStack(spacing: 13) {
                            Image(systemName: "alternatingcurrent")
                                .font(.system(size: 30))
                            Text("軟便")
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        selectedSoft.toggle()
                        if selectedSoft {
                            selectedType.append(.soft)
                        } else {
                            selectedType.removeAll { $0 == .soft }
                        }
                        
                    }
                }
                
                VStack(spacing: 17) {
                    let rgbOrange = Color(red: 255/255, green: 227/255, blue: 203/255)
                    
                    let rgbOrange2 = Color(red: 254/255, green: 207/255, blue: 126/255)
                    
                    CustomAddButtonView(color: rgbOrange, color2: rgbOrange2, isPresented: $selectedDiarrhea) {
                        VStack(spacing: 13) {
                            Image(systemName: "wind")
                                .font(.system(size: 30))
                            Text("下痢")
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        selectedDiarrhea.toggle()
                        if selectedDiarrhea {
                            selectedType.append(.diarrhea)
                        } else {
                            selectedType.removeAll { $0 == .diarrhea }
                        }
                    }
                    
                    let rgbGray = Color(red: 213/255, green: 214/255, blue: 216/255)
                    let rgbGray2 = Color(red: 189/255, green: 191/255, blue: 195/255)
                    
                    CustomAddButtonView(color: rgbGray, color2: rgbGray2, isPresented: $selectedConstipation) {
                        VStack(spacing: 13) {
                            Image(systemName: "xmark")
                                .font(.system(size: 30))
                            Text("便秘")
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        selectedConstipation.toggle()
                        if selectedConstipation {
                            selectedType.append(.constipation)
                        } else {
                            selectedType.removeAll { $0 == .constipation }
                        }
                        
                    }
                    
                    let rgbRed = Color(red: 254/255, green: 216/255, blue: 216/255)
                    let rgbRed2 = Color(red: 254/255, green: 166/255, blue: 166/255)
                    
                    CustomAddButtonView(color: rgbRed, color2: rgbRed2, isPresented: $selectedBlood) {
                        VStack(spacing: 13) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 30))
                            Text("血便")
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        selectedBlood.toggle()
                        if selectedBlood {
                            selectedType.append(.blood)
                        } else {
                            selectedType.removeAll { $0 == .blood }
                        }
                        
                    }
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
        .onAppear {
            restoreStates()
        }
    }
    
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
    
    private func restoreStates() {
        if toggleFixed {
            if selectedNormal { selectedType.append(.normal) }
            if selectedHard { selectedType.append(.hard) }
            if selectedSoft { selectedType.append(.soft) }
            if selectedDiarrhea { selectedType.append(.diarrhea) }
            if selectedConstipation { selectedType.append(.constipation) }
            if selectedBlood { selectedType.append(.blood) }
        } else {
            selectedNormal = false
            selectedHard = false
            selectedSoft = false
            selectedDiarrhea = false
            selectedConstipation = false
            selectedBlood = false
            selectedType.removeAll()
        }
    }
}

#Preview {
    AddStoolRecord(selectDay: .constant(Date()), showView: {})
}
