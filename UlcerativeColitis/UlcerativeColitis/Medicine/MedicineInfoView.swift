//
//  MedicineInfoView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/27.
//

import SwiftUI
import RealmSwift

struct MedicineInfoView: View {
    
    @ObservedResults(MedicineInfo.self) var medicineInfo
    @ObservedResults(UnitArray.self) var unitArray
//    @ObservedResults(MedicineInfo.self) var medicineInfo
    @ObservedResults(MedicineTime.self) var times
    
    @ObservedRealmObject var medicine: MedicineInfo
    
    @State private var medicineName: String = ""
    @State private var dosage: Int = 0
    @State private var selectedFirstTimings: Set<FirstTiming> = []
    @State private var tentativeTime: [Date] = []
    @State private var selectedSecondTiming: SecondTiming = .justBeforeMeals
    @State private var draftSecondTiming: SecondTiming = .justBeforeMeals
    @State private var effect: String = ""
    @State private var stock: String = ""
    @State private var memo: String = ""
    @State private var morningDosage: Int = 0
    @State private var noonDosage: Int = 0
    @State private var eveningDosage: Int = 0
    @State private var showPicker = false
    @State private var time: Date = Date()
    
    @State private var showCustomUnitView = false
    @State private var showStockUnitView = false //在庫単位選択用シート表示
    @State private var showTimeView = false
    
    @State private var selectedUnit: UnitArray?
    @State private var selectedStockUnit: UnitArray? //在庫用単位の選択状態
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("お薬の名前")
                    .font(.callout)
                TextField("", text: $medicineName)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            Divider()
                .background(.black)
                .padding(.horizontal)
            
            HStack {
                Text("1回")
                    .font(.callout)
                
                Divider()
                    .frame(height: 0.7)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .padding(.horizontal, 8)
                
                TextField("", value: $dosage, format: .number)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    showCustomUnitView.toggle()
                }) {
                    Text(getDosageUnitDisplayText())
                        .borderedTextStyle()
                }
                .sheet(isPresented: $showCustomUnitView) {
                    CustomUnitView(selectedUnit: $selectedUnit,
                                   onTap: { showCustomUnitView = false })
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(.gray)
                .padding(.horizontal)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear.opacity(0.3))
                    .frame(height: 150)
                VStack(spacing: 15) {
                    HStack {
                        Text("服用時間")
                            .font(.callout)
                        
                        Divider()
                            .frame(height: 0.7)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .padding(.horizontal, 8)
                        
                        Button(action: {
                            draftSecondTiming = selectedSecondTiming
                            showPicker.toggle()
                        }) {
//                            if let firstMedicine = medicineInfo.first {
//                                Text(firstMedicine.secondTiming.japaneseText)
//                                    .foregroundColor(.black)
//                            } else {
                                Text(selectedSecondTiming.japaneseText)
                                    .foregroundColor(.black)
//                            }
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray.opacity(0.3))
                        )
                        .padding(.horizontal)
                        .sheet(isPresented: $showPicker) {
                            TimingPickerView(timing: $draftSecondTiming,
                                             cancel: { showPicker = false},
                                             done: { showPicker = false
                                selectedSecondTiming = draftSecondTiming
//                                saveSecondTiming()
                            }
                            )
                            .presentationDetents([.height(250)])
                            .interactiveDismissDisabled(true)
                            .presentationCornerRadius(30)
                        }
                    }
                    HStack {
                        VStack(alignment: .center) {
                            VStack {
                                ForEach([FirstTiming.morning, .noon, .evening], id: \.self) { timing in
                                    HStack {
                                        CustomButton(
                                            color: selectedFirstTimings.contains(timing) ? getColor(for: timing) : .white,
                                            selected: selectedFirstTimings,
                                            timing: timing,
                                            action: {
                                                toggle(timing)
                                                saveTiming()
                                            }) {
                                                Text(timing.japaneseText)
                                                    .font(.system(size: 17))
                                            }
                                            .frame(width: 100, height: 30)
                                        HStack {
                                            dosageTextField(for: timing)
                                            Text(getUnitDisplayText())
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            
                            HStack {
                                ForEach([FirstTiming.wakeUp, .bedtime, .temporaryClothes], id: \.self) { timing in
                                    CustomButton(
                                        color: selectedFirstTimings.contains(timing) ? getColor(for: timing) : .white,
                                        selected: selectedFirstTimings,
                                        timing: timing,
                                        action: {
                                            toggle(timing)
                                            saveTiming()
                                        }) {
                                            Text(timing.japaneseText)
                                                .font(.system(size: 17))
                                        }
                                        .frame(width: 100, height: 30)
                                }
                            }
                            .padding(.vertical, 5)
                            
                        }
                    }
                    
//                    ForEach(times, id: \.id) { timeEntry in
//                        HStack {
//                            Text(timeEntry.time.formatted(date: .omitted, time: .shortened))
//                                .font(.system(size: 15))
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                deleteTime(timeEntry)
//                            }) {
//                                Image(systemName: "trash")
//                                    .foregroundColor(.red)
//                                    .font(.system(size: 14))
//                            }
//                        }
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 8)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.white)
//                        )
//                    }
                    
                    if let firstMedicine = medicineInfo.first, !firstMedicine.time.isEmpty {
                        ForEach(firstMedicine.time, id: \.id) { timeEntry in
                            Text(timeEntry.time.formatted(date: .omitted, time: .shortened))
                        }
                    } else {
                        ForEach(tentativeTime, id: \.self) { time in
                            Text(time.formatted(date: .omitted, time: .shortened))
                        }
                    }
                    
                    Button(action: {
                        showTimeView.toggle()
                    }) {
                        Text("時間を追加")
                            .foregroundColor(.black.opacity(0.7))
                            .font(.system(size: 14))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 80, height: 25)
                            )
                    }
                    .sheet(isPresented: $showTimeView) {
                        TimeView(time: $time, done: {
                            showTimeView = false
                            tentativeTime.append(time)
//                            saveTime()
                        })
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(.gray)
                .padding(.horizontal)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $effect)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4))
                    )
                Text("効果")
                    .foregroundColor(effect.isEmpty ? Color.gray.opacity(0.5) : Color.clear)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
            }
            .padding(.horizontal)
            
            Divider()
                .background(.gray)
                .padding(.horizontal)
            
            HStack {
                Text("在庫")
                    .font(.callout)
                Divider()
                    .frame(height: 0.7)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .padding(.horizontal, 8)
                
//                TextField("", text: String($stock))
//                    .textFieldStyle(.roundedBorder)
//                    .multilineTextAlignment(.trailing)
//                    .frame(width: 100)
                TextField("在庫数", text: $stock)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                Button(action: {
                    showStockUnitView.toggle()
                }) {
                    Text(getStockUnitDisplayText())
                        .borderedTextStyle()
                }
                .sheet(isPresented: $showStockUnitView) {
                    CustomUnitView(selectedUnit: $selectedStockUnit,
                                   onTap: { showStockUnitView = false })
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(.gray)
                .padding(.horizontal)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $memo)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4))
                    )
                Text("メモ")
                    .foregroundColor(memo.isEmpty ? Color.gray.opacity(0.5) : Color.clear)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
            }
            .padding(.horizontal)
            
            Button(action: {
                saveMedicine()
            }) {
                Text("保存")
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .onAppear {
            // 既存の medicine オブジェクトから値を反映
            selectedFirstTimings = Set(medicine.firstTiming)
            medicineName = medicine.medicineName
            dosage = medicine.dosage ?? 0
            morningDosage = medicine.morningDosage ?? 0
            noonDosage = medicine.noonDosage ?? 0
            eveningDosage = medicine.eveningDosage ?? 0
            effect = medicine.effect ?? ""
            stock = String(medicine.stock ?? 0)
            memo = medicine.memo ?? ""
            selectedSecondTiming = medicine.secondTiming
            selectedUnit = medicine.unit
            selectedStockUnit = medicine.stockUnit?.unit
            tentativeTime = medicine.time.map { $0.time }
        }
    }
    
    private func saveMedicine() {
        let realm = try! Realm()
        
        try! realm.write {
            let model = MedicineInfo()
            model.medicineName = medicineName
            model.dosage = dosage
            model.morningDosage = morningDosage
            model.noonDosage = noonDosage
            model.eveningDosage = eveningDosage
            model.effect = effect
            model.memo = memo
            model.secondTiming = selectedSecondTiming
            model.firstTiming.append(objectsIn: Array(selectedFirstTimings))
            if let stockInt = Int(stock) {
                model.stock = stockInt
            } else {
                model.stock = 0 // またはエラーハンドリング
            }

            // Optional に安全代入
            if let selectedUnit = selectedUnit {
                model.unit = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
            }
            
            if let selectedStockUnit = selectedStockUnit {
                let stockUnit = StockUnit()
                stockUnit.unit = realm.create(UnitArray.self, value: selectedStockUnit, update: .modified)
                model.stockUnit = stockUnit
            }
            
            
            // 時間リストの仮保存（tentativeTime → MedicineTime 変換）
            for t in tentativeTime {
                let tModel = MedicineTime()
                tModel.time = t
                model.time.append(tModel)
            }
            
            realm.add(model)
            
            selectedFirstTimings = []
        }
    }

    private func toggle(_ timing: FirstTiming) {
        if selectedFirstTimings.contains(timing) {
            selectedFirstTimings.remove(timing)
        } else {
            selectedFirstTimings.insert(timing)
        }
    }
    
    private func saveTiming() {
        let realm = try! Realm()
        
        try! realm.write {
            if let frozenModel = medicineInfo.first?.thaw() {
                // thaw() でライブオブジェクトに変換
                frozenModel.firstTiming.removeAll()
                for t in selectedFirstTimings {
                    frozenModel.firstTiming.append(t)
                }
            } else {
                // 既存データがない場合は新規追加
                let model = MedicineInfo()
                for t in selectedFirstTimings {
                    model.firstTiming.append(t)
                }
                realm.add(model)
            }
        }
    }
    
    private func saveSecondTiming() {
        let realm = try! Realm()
        
        try! realm.write {
            if let frozenModel = medicineInfo.first?.thaw() {
                // thaw() でライブオブジェクトに変換
                frozenModel.secondTiming = selectedSecondTiming
            } else {
                // 既存データがない場合は新規追加
                let model = MedicineInfo()
                model.secondTiming = selectedSecondTiming
                realm.add(model)
            }
        }
    }
    
    private func saveTime() {
//        let realm = try! Realm()
//        
//        
//        try! realm.write {
//            let model = MedicineTime()
//            model.time = time
//            realm.add(model)
//        }
    }

    
    private func deleteTime(_ timeEntry: MedicineTime) {
        let realm = try! Realm()
        
        if let objectToDelete = realm.object(ofType: MedicineTime.self, forPrimaryKey: timeEntry.id) {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
    
    func getColor(for timing: FirstTiming) -> Color {
        switch timing {
        case .morning:
            return .orange.opacity(0.3)
        case .noon:
            return .yellow.opacity(0.3)
        case .evening:
            return .purple.opacity(0.3)
        case .wakeUp:
            return .green.opacity(0.3)
        case .bedtime:
            return .blue.opacity(0.3)
        case .temporaryClothes:
            return .gray.opacity(0.3)
        }
    }
    
    private func getStockUnitDisplayText() -> String {
        if let firstStockUnit = medicineInfo.first?.stockUnit,
           let unitName = firstStockUnit.unit?.unitName {
            return unitName
        } else if let selectedStockUnit = selectedStockUnit {
            return selectedStockUnit.unitName
        } else if let selectedUnit = selectedUnit {
            return selectedUnit.unitName
        } else if let firstUnit = unitArray.first {
            return firstUnit.unitName
        } else {
            return "-"
        }
    }
    
    // ヘルパー関数
    @ViewBuilder
    private func dosageTextField(for timing: FirstTiming) -> some View {
        switch timing {
        case .morning:
            TextField("", value: $morningDosage, format: .number)
        case .noon:
            TextField("", value: $noonDosage, format: .number)
        case .evening:
            TextField("", value: $eveningDosage, format: .number)
        default:
            EmptyView()
        }
    }
    
    private func getUnitDisplayText() -> String {
        if let selectedUnit = selectedUnit,
           unitArray.contains(where: { $0.id == selectedUnit.id }) {
            return selectedUnit.unitName
        } else if let firstUnit = unitArray.first {
            return firstUnit.unitName
        } else {
            return "-"
        }
    }
    
    private func getDosageUnitDisplayText() -> String {
        if let selectedUnit = selectedUnit,
           unitArray.contains(where: { $0.id == selectedUnit.id }) {
            return selectedUnit.unitName
        } else if let firstUnit = unitArray.first {
            return firstUnit.unitName
        } else {
            return "-"
        }
    }
}

//#Preview {
//    MedicineInfoView(, medicine: <#MedicineInfo#>)
//}

struct BorderedTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .padding(4.5)
            .background(
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

extension View {
    func borderedTextStyle() -> some View {
        self.modifier(BorderedTextStyle())
    }
}
