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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var medicineName: String = ""
    @State private var dosage: Int?
    @State private var dosageText: String = ""
    @State private var selectedFirstTimings: Set<FirstTiming> = []
    @State private var tentativeTime: [Date] = []
    @State private var selectedSecondTiming: SecondTiming = .justBeforeMeals
    @State private var draftSecondTiming: SecondTiming = .justBeforeMeals
    @State private var effect: String = ""
    @State private var stock: Int?
    @State private var toggleEffect: Bool = false
    @State private var stockText: String = ""
    @State private var memo: String = ""
    @State private var toggleMemo: Bool = false
    @State private var morningDosage: Int?
    @State private var morningDosageText: String = ""
    @State private var noonDosage: Int?
    @State private var noonDosageText: String = ""
    @State private var eveningDosage: Int?
    @State private var eveningDosageText: String = ""
    @State private var showPicker = false
    @State private var time: Date = Date()
    
    @State private var showCustomUnitView = false
    @State private var showStockUnitView = false //在庫単位選択用シート表示
    @State private var showTimeView = false
    @State private var showDeleteAlert = false
    @State private var showIsUsingAlert = false
    @State private var showEffectDeleteAlert = false
    @State private var showMemoDeleteAlert = false
    
    @State private var selectedUnit: UnitArray?
    @State private var selectedStockUnit: UnitArray? //在庫用単位の選択状態
    
    var isNewMedicine: Bool {
        // IDが空文字列なら新規（実際にはUUIDが自動生成されるので別の判定が必要）
        // または、medicine.medicineNameが空なら新規と判定
        medicine.realm == nil  // Realmに保存されていなければ新規
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("お薬の名前")
                        .font(.footnote)
                    TextField("", text: $medicineName)
//                        .frame(height: 37)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
//                Divider()
//                    .background(.black)
//                    .padding(.horizontal)
                
                HStack {
                    Text("1回")
                        .font(.footnote)
                    
                    Divider()
                        .frame(height: 0.7)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .padding(.horizontal, 8)
                    
                    //                TextField("", text: $dosageText)
                    //                    .multilineTextAlignment(.trailing)
                    //                    .frame(width: 100)
                    //                    .textFieldStyle(.roundedBorder)
                    //                    .keyboardType(.decimalPad)
                    NoMenuTextField(text: $dosageText, keyboardType: .decimalPad)
                        .frame(width: 100, height: 36)
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
                
//                Divider()
//                    .background(.gray)
//                    .padding(.horizontal)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear.opacity(0.3))
                        .frame(height: 150)
                    VStack(spacing: 15) {
                        HStack {
                            Text("服用時間")
                                .font(.footnote)

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
                                    .lineLimit(1)
                                    .foregroundColor(.black)
                                //                            }
                            }
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray.opacity(0.3))
                            )
//                            .padding(.horizontal)
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
                                                .frame(width: 60, height: 30)
                                            HStack {
                                                dosageTextField(for: timing)
                                                    .frame(width: 60, height: 36)
                                                    .textFieldStyle(.roundedBorder)
                                                
                                                Text(getUnitDisplayText())
                                                    .foregroundColor(isDosageEmpty(for: timing) ? .gray : .black)
                                                    .font(.footnote)
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
                            HStack {
                                ForEach(firstMedicine.time, id: \.id) { timeEntry in
                                    HStack {
                                        Text(timeEntry.time.formatted(date: .omitted, time: .shortened))
                                            .font(.system(size: 14))
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            deleteTime(timeEntry)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                    )
                                }
                            }
                        } else {
                            HStack {
                                ForEach(Array(tentativeTime.sorted().enumerated()), id: \.offset) { index, time in
                                    HStack {
                                        Text("\(index + 1)")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                        Text(time.formatted(date: .omitted, time: .shortened))
                                            .font(.system(size: 14))
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if let originalIndex = tentativeTime.firstIndex(of: time) {
                                                tentativeTime.remove(at: originalIndex)
                                            }
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                    )
                                }
                            }
                        }
                        
//                        if let firstMedicine = medicineInfo.first {
//                            let totalCount = firstMedicine.time.count + tentativeTime.count
//                            if totalCount.count 3 {
                        if let firstMedicine = medicineInfo.first {
                            // どちらかが3つ未満ならボタンを表示
                            if firstMedicine.time.count < 3 && tentativeTime.count < 3 {
                                Button(action: {
                                    showTimeView.toggle()
                                }) {
                                    Text("時間を追加")
                                        .foregroundColor(.black.opacity(0.7))
                                        .font(.caption)
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
                                    })
                                }
                            }
                        }
//                        .sheet(isPresented: $showTimeView) {
//                            TimeView(time: $time, done: {
//                                showTimeView = false
//                                tentativeTime.append(time)
//                            })
//                        }
                    }
                }
                .padding(.horizontal)
                
//                Divider()
//                    .background(.gray)
//                    .padding(.horizontal)
//                
//                ZStack(alignment: .topLeading) {
//                    TextEditor(text: $effect)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 60)
//                        .padding(2)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray.opacity(0.4))
//                        )
//                    Text("効果")
//                        .foregroundColor(effect.isEmpty ? Color.gray.opacity(0.5) : Color.clear)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 10)
//                }
//                .padding(.horizontal)
                
//                Divider()
//                    .background(.gray)
//                    .padding(.horizontal)
                
                HStack {
                    Text("在庫")
                        .font(.caption)
                    Divider()
                        .frame(height: 0.7)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .padding(.horizontal, 8)
                    
                    //                TextField("", text: String($stock))
                    //                    .textFieldStyle(.roundedBorder)
                    //                    .multilineTextAlignment(.trailing)
                    //                    .frame(width: 100)
                    //                TextField("在庫数", text: $stockText)
                    //                    .keyboardType(.numberPad)
                    //                    .textFieldStyle(.roundedBorder)
                    //                    .keyboardType(.decimalPad)
                    NoMenuTextField(text: $stockText, keyboardType: .decimalPad)
                        .frame(width: 100, height: 36)
                        .textFieldStyle(.roundedBorder)
                    
                    //                Button(action: {
                    //                    showStockUnitView.toggle()
                    //                }) {
                    //                    Text(getStockUnitDisplayText())
                    //                        .borderedTextStyle()
                    //                }
                    //                .sheet(isPresented: $showStockUnitView) {
                    //                    CustomUnitView(selectedUnit: $selectedStockUnit,
                    //                                   onTap: { showStockUnitView = false })
                    //                }
                    Text(getDosageUnitDisplayText())
                    //                    .borderedTextStyle()
                        .font(.footnote)
                }
                .padding(.horizontal)
                
//                Divider()
//                    .background(.gray)
//                    .padding(.horizontal)
                
//                ZStack(alignment: .topLeading) {
//                    TextEditor(text: $memo)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 60)
//                        .padding(2)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray.opacity(0.4))
//                        )
//                    Text("メモ")
//                        .foregroundColor(memo.isEmpty ? Color.gray.opacity(0.5) : Color.clear)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 10)
//                }
//                .padding(.horizontal)
                
                if toggleEffect {
                    HStack {
                        TextField("効果", text: $effect)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: {
//                            toggleEffect = false
                            showEffectDeleteAlert.toggle()
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
//                        CommonAlertModifier(isPresented: $showEffectDeleteAlert,
//                                            title: "削除の確認",
//                                            message: "効果の内容も削除されます",
//                                            done: "削除",
//                                            confirmAction: {
//                            toggleEffect = false
//                            effect = ""
//                        })
                        .commonAlert(isPresented: $showEffectDeleteAlert,
                                     title: "削除の確認",
                                     message: "効果の内容も削除されます",
                                     confirmAction: {
                            toggleEffect = false
                            effect = ""
                        })
                    }
                    .padding(.horizontal)
                }
                
                if toggleMemo {
                    HStack {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $memo)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .padding(2)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.1))
                                )
                            Text("メモ")
                                .foregroundColor(memo.isEmpty ? Color.gray.opacity(0.5) : Color.clear)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                        }
                        
                        Button(action: {
                            showMemoDeleteAlert.toggle()
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
                        .commonAlert(isPresented: $showMemoDeleteAlert,
                                     title: "削除の確認",
                                     message: "メモの内容も削除されます",
                                     confirmAction: {
                            toggleMemo = false
                            memo = ""
                        })
                    }
                    .padding(.horizontal)
                }
                
                HStack(spacing: 30) {
                    if !toggleEffect {
                        Button(action: {
                            toggleEffect = true
                        }) {
                            HStack(spacing: 1) {
                                Text("効果")
                                Image(systemName: "plus")
                            }
                            .font(.footnote)
                            .foregroundColor(.black)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 60, height: 30)
                            )
                        }
                    }
                    
                    if !toggleMemo {
                        Button(action: {
                            toggleMemo = true
                        }) {
                            HStack(spacing: 1) {
                                Text("メモ")
                                Image(systemName: "plus")
                            }
                            .font(.footnote)
                            .foregroundColor(.black)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 60, height: 30)
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        saveMedicine()
                    }) {
                        Text("保存")
                    }
                    
//                    if isNewMedicine {
//                        Button(action: {
//                        }) {
//                            Text("キャンセル")
//                        }
//                    } else {
//                        Button(action: {
//                            showDeleteAlert.toggle()
//                        }) {
//                            Text("削除")
//                        }
//                        .alert("削除の確認", isPresented: $showDeleteAlert) {
//                            Button("キャンセル", role: .cancel) {}
//                            Button("削除") {
//                                deleteMedicine(by: medicine.id)
//                                dismiss()
//                            }
//                        } message: {
//                            Text("「\(medicine.medicineName)」を削除しますか？")
//                        }
//                    }
                    
                    //                .alert("削除", message: "本当に削除しますか？", isPresented: $showDeleteAlert) {
                    //                    Button("キャンセル", role: .cancel) {}
                    //                    Button("削除") {
                    //                        deleteMedicine(by: medicine.id)
                    //                        dismiss()
                    //                    }
                    //                }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .onAppear {
                // 既存の medicine オブジェクトから値を反映
                selectedFirstTimings = Set(medicine.firstTiming)
                medicineName = medicine.medicineName
                dosageText = medicine.dosage.map { String($0) } ?? ""
                //            morningDosage = medicine.morningDosage ?? 0
                //            noonDosage = medicine.noonDosage ?? 0
                //            eveningDosage = medicine.eveningDosage ?? 0
                morningDosageText = medicine.morningDosage.map { String($0) } ?? ""
                noonDosageText = medicine.noonDosage.map { String($0) } ?? ""
                eveningDosageText = medicine.eveningDosage.map { String($0) } ?? ""
                effect = medicine.effect ?? ""
                //            stock = String(medicine.stock ?? 0)
                stockText = medicine.stock.map { String($0) } ?? ""
                memo = medicine.memo ?? ""
                selectedSecondTiming = medicine.secondTiming
                selectedUnit = medicine.unit
                //            selectedStockUnit = medicine.stockUnit?.unit
                tentativeTime = medicine.time.map { $0.time }
                toggleEffect = medicine.toggleEffect
                toggleMemo = medicine.toggleMemo
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            showDeleteAlert.toggle()
                        }) {
                            Text("削除")
                        }
                        
                        Button(action: {
                            showIsUsingAlert.toggle()
                        }) {
                            Text("不使用にする")
                        }

                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .alert("削除の確認", isPresented: $showDeleteAlert) {
                        Button("キャンセル", role: .cancel) {}
                        Button("削除") {
                            deleteMedicine(by: medicine.id)
                            dismiss()
                        }
                    } message: {
                        Text("「\(medicine.medicineName)」を削除しますか？")
                    }
                    .alert("不使用", isPresented: $showIsUsingAlert) {
                        Button("キャンセル", role: .cancel) {}
                        Button("不使用") {
                            isUsingChange()
                        }
                    } message: {
                        Text("「\(medicine.medicineName)」を不使用にしますか？")
                        Text("削除はされず、不使用リストに移動します。")
                    }
                }
            }
        }
    }
    
    private func saveMedicine() {
        let realm = try! Realm()
        
        try! realm.write {
            if isNewMedicine {
                // 新規作成
                let model = MedicineInfo()
                model.medicineName = medicineName
//                model.dosage = dosage
                model.morningDosage = morningDosage
                model.noonDosage = noonDosage
                model.eveningDosage = eveningDosage
                model.effect = effect
                model.memo = memo
                model.secondTiming = selectedSecondTiming
                model.firstTiming.append(objectsIn: Array(selectedFirstTimings))
                model.toggleEffect = toggleEffect
                model.toggleMemo = toggleMemo
                
                if let selectedUnit = selectedUnit {
                    model.unit = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
                }
                
//                if let selectedStockUnit = selectedStockUnit {
//                    let stockUnit = StockUnit()
//                    stockUnit.unit = realm.create(UnitArray.self, value: selectedStockUnit, update: .modified)
//                    model.stockUnit = stockUnit
//                }
                
                if let dosage = Int(dosageText) {
                    model.dosage = dosage
                }
                
                if let stockInt = Int(stockText) {
                    model.stock = stockInt
                }
                
                for t in tentativeTime {
                    let tModel = MedicineTime()
                    tModel.time = t
                    model.time.append(tModel)
                }
                
                realm.add(model)
                
                medicineName = ""
                dosageText = ""
                selectedUnit = nil
                selectedFirstTimings = []
                morningDosageText = ""
                noonDosageText = ""
                eveningDosageText = ""
                selectedSecondTiming = .justBeforeMeals
                effect = ""
                stockText = ""
//                selectedStockUnit = nil
                memo = ""
                tentativeTime = []
                toggleEffect = false
                toggleMemo = false
                
            } else {
                // 既存データの更新
                if let thawedMedicine = medicine.thaw() {
                    thawedMedicine.medicineName = medicineName
//                    thawedMedicine.dosage = dosage
//                    thawedMedicine.morningDosage = morningDosage
//                    thawedMedicine.noonDosage = noonDosage
//                    thawedMedicine.eveningDosage = eveningDosage
                    thawedMedicine.effect = effect
                    thawedMedicine.memo = memo
                    thawedMedicine.secondTiming = selectedSecondTiming
                    
                    thawedMedicine.firstTiming.removeAll()
                    thawedMedicine.firstTiming.append(objectsIn: Array(selectedFirstTimings))
                    thawedMedicine.toggleEffect = toggleEffect
                    thawedMedicine.toggleMemo = toggleMemo
                    
                    if let selectedUnit = selectedUnit {
                        thawedMedicine.unit = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
                    } else {
                        thawedMedicine.unit = nil
                    }
                    
//                    if let selectedStockUnit = selectedStockUnit {
//                        if thawedMedicine.stockUnit == nil {
//                            thawedMedicine.stockUnit = StockUnit()
//                        }
//                        thawedMedicine.stockUnit?.unit = realm.create(UnitArray.self, value: selectedStockUnit, update: .modified)
//                    } else {
//                        thawedMedicine.stockUnit = nil
//                    }
                    
                    if let stockInt = Int(stockText) {
                        thawedMedicine.stock = stockInt
                    } else {
                        thawedMedicine.stock = nil
                    }
                    
                    if let dosageInt = Int(dosageText) {
                        thawedMedicine.dosage = dosageInt
                    } else {
                        thawedMedicine.dosage = nil
                    }
                    
                    if let morningDosageInt = Int(morningDosageText) {
                        thawedMedicine.morningDosage = morningDosageInt
                    } else {
                        thawedMedicine.morningDosage = nil
                    }
                    
                    if let noonDosageInt = Int(noonDosageText) {
                        thawedMedicine.noonDosage = noonDosageInt
                    } else {
                        thawedMedicine.noonDosage = nil
                    }
                    
                    if let eveningDosageInt = Int(eveningDosageText) {
                        thawedMedicine.eveningDosage = eveningDosageInt
                    } else {
                        thawedMedicine.eveningDosage = nil
                    }
                    
                    thawedMedicine.time.removeAll()
                    for t in tentativeTime {
                        let tModel = MedicineTime()
                        tModel.time = t
                        thawedMedicine.time.append(tModel)
                    }
                }
            }
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
    
    private func isUsingChange() {
        let realm = try! Realm()
        try! realm.write {
            if let thawedMedicine = medicine.thaw() {
                thawedMedicine.isUsing = false
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
            NoMenuTextField(text: $morningDosageText, keyboardType: .decimalPad)
        case .noon:
            NoMenuTextField(text: $noonDosageText, keyboardType: .decimalPad)
        case .evening:
            NoMenuTextField(text: $eveningDosageText, keyboardType: .decimalPad)
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
    
    private func isDosageEmpty(for timing: FirstTiming) -> Bool {
        switch timing {
        case .morning:
            return morningDosageText.isEmpty
        case .noon:
            return noonDosageText.isEmpty
        case .evening:
            return eveningDosageText.isEmpty
        default:
            return true
        }
    }
    
    private func deleteMedicine(by id: String) {
        let realm = try! Realm()
        
        try! realm.write {
            if let medicineToDelete = realm.object(ofType: MedicineInfo.self, forPrimaryKey: id) {
                // 関連オブジェクトも削除したい場合はここで削除
                // realm.delete(medicineToDelete.time)
                // realm.delete(medicineToDelete.unit)
                
                realm.delete(medicineToDelete)
            }
        }
    }
}

#Preview {
    MedicineInfoView(medicine: MedicineInfo())
}

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
