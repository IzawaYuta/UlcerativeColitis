//
//  MedicineInfoView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/27.
//

import SwiftUI
import RealmSwift
import DynamicColor

struct MedicineInfoView: View {
    
    @ObservedResults(MedicineInfo.self) var medicineInfo
    @ObservedResults(UnitArray.self) var unitArray
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
        medicine.realm == nil  // Realmに保存されていなければ新規
    }
    
    var body: some View {
        NavigationStack {
            ScrollView() {
                VStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("お薬の名前")
                            .font(.footnote)
                        TextField("", text: $medicineName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(.black)
                        .padding(.horizontal, 1)
                    
                    HStack {
                        Text("1回")
                            .font(.footnote)
                        
                        Divider()
                            .frame(height: 0.7)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .padding(.horizontal, 8)
                        
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
                            .presentationDetents([.large])
                            .presentationCornerRadius(30)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(.black)
                        .padding(.horizontal, 1)
                    
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
                                    Text(selectedSecondTiming.japaneseText)
                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.gray.opacity(0.3))
                                )
                                .sheet(isPresented: $showPicker) {
                                    TimingPickerView(timing: $draftSecondTiming,
                                                     cancel: { showPicker = false},
                                                     done: { showPicker = false
                                        selectedSecondTiming = draftSecondTiming
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
                                                        .frame(width: 100, height: 36)
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
                                    
                                }
                            }
                            
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
                                                    .foregroundColor(.red.opacity(0.5))
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
                                                    .foregroundColor(.red.opacity(0.5))
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
                            
                            if (medicineInfo.first?.time.count ?? 0) < 3 && tentativeTime.count < 3 {
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
                                    .padding(.bottom, 6)
                                    .sheet(isPresented: $showTimeView) {
                                        TimeView(time: $time, done: {
                                            showTimeView = false
                                            tentativeTime.append(time)
                                        })
                                        .presentationDetents([.height(350)])
                                        .presentationCornerRadius(30)
                                    }
//                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(.black)
                        .padding(.horizontal, 1)
                    
                    HStack {
                        Text("在庫")
                            .font(.caption)
                        Divider()
                            .frame(height: 0.7)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .padding(.horizontal, 8)
                        
                        NoMenuTextField(text: $stockText, keyboardType: .decimalPad)
                            .frame(width: 100, height: 36)
                            .textFieldStyle(.roundedBorder)
                        
                        Text(getDosageUnitDisplayText())
                            .font(.footnote)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(.black)
                        .padding(.horizontal, 1)
                    
                    if toggleEffect {
                        HStack {
                            TextField("効果", text: $effect)
                                .textFieldStyle(.roundedBorder)
                            
                            Button(action: {
                                showEffectDeleteAlert.toggle()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red.opacity(0.5))
                                    .font(.system(size: 14))
                            }
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
                                    .foregroundColor(.red.opacity(0.5))
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
                    
                    HStack/*(spacing: 30)*/ {
                        //                        if !toggleEffect {
                        //                            Button(action: {
                        //                                toggleEffect = true
                        //                            }) {
                        //                                HStack(spacing: 1) {
                        //                                    Text("効果")
                        //                                    Image(systemName: "plus")
                        //                                }
                        //                                .font(.footnote)
                        //                                .foregroundColor(.black)
                        //                                .background(
                        //                                    Capsule()
                        //                                        .fill(Color.blue.opacity(0.2))
                        //                                        .frame(width: 60, height: 30)
                        //                                )
                        //                            }
                        //                        }
                        
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
                    .padding(5)
                    
                    Spacer()
                    
                    Button(action: {
                        saveMedicine()
                        dismiss()
                    }) {
                        Text("保存")
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.blue.opacity(0.75))
                                    .frame(width: 100, height: 30)
                            )
                    }
                    .padding()
                    
                }
                .padding(.horizontal)
                .onAppear {
                    // 既存の medicine オブジェクトから値を反映
                    selectedFirstTimings = Set(medicine.firstTiming)
                    medicineName = medicine.medicineName
                    dosageText = medicine.dosage.map { String($0) } ?? ""
                    morningDosageText = medicine.morningDosage.map { String($0) } ?? ""
                    noonDosageText = medicine.noonDosage.map { String($0) } ?? ""
                    eveningDosageText = medicine.eveningDosage.map { String($0) } ?? ""
                    //                    effect = medicine.effect ?? ""
                    stockText = medicine.stock.map { String($0) } ?? ""
                    memo = medicine.memo ?? ""
                    selectedSecondTiming = medicine.secondTiming
                    selectedUnit = medicine.unit
                    tentativeTime = medicine.time.map { $0.time }
                    //                    toggleEffect = medicine.toggleEffect
                    toggleMemo = medicine.toggleMemo
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            if !isNewMedicine {
                                Button(action: {
                                    showDeleteAlert.toggle()
                                }) {
                                    Text("削除")
                                }
                                
                                if medicine.isUsing {
                                    Button(action: {
                                        showIsUsingAlert.toggle()
                                    }) {
                                        Text("不使用にする")
                                    }
                                } else {
                                    Button(action: {
                                        showIsUsingAlert.toggle()
                                    }) {
                                        Text("使用中にする")
                                    }
                                }
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .alert("削除の確認", isPresented: $showDeleteAlert) {
                            Button("キャンセル", role: .cancel) {}
                            Button("削除", role: .destructive) {
                                deleteMedicine(by: medicine.id)
                                dismiss()
                            }
                        } message: {
                            Text("「\(medicine.medicineName)」を削除しますか？")
                        }
                        .alert("不使用", isPresented: $showIsUsingAlert) {
                            Button("キャンセル", role: .cancel) {}
                            if medicine.isUsing {
                                Button("不使用") {
                                    isUsingChange()
                                    dismiss()
                                }
                            } else {
                                Button("使用") {
                                    isUsingChange()
                                    dismiss()
                                }
                            }
                        } message: {
                            Text("「\(medicine.medicineName)」を不使用にしますか？")
                            Text("削除はされず、不使用リストに移動します。")
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
        }
    }
    
    private func saveMedicine() {
        let realm = try! Realm()
        
        try! realm.write {
            if isNewMedicine {
                // 新規作成
                let model = MedicineInfo()
                model.medicineName = medicineName
//                model.morningDosage = morningDosage
//                model.noonDosage = noonDosage
//                model.eveningDosage = eveningDosage
                //                model.effect = effect
                model.memo = memo
                model.secondTiming = selectedSecondTiming
                model.firstTiming.append(objectsIn: Array(selectedFirstTimings))
                //                model.toggleEffect = toggleEffect
                model.toggleMemo = toggleMemo
                
                if let selectedUnit = selectedUnit {
                    model.unit = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
                }
                
                if let morningDosage = Int(morningDosageText) {
                    model.morningDosage = morningDosage
                }
                
                if let noonDosage = Int(noonDosageText) {
                    model.noonDosage = noonDosage
                }
                
                if let eveningDosage = Int(eveningDosageText) {
                    model.eveningDosage = eveningDosage
                }
                
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
                memo = ""
                tentativeTime = []
                //                toggleEffect = false
                toggleMemo = false
                
            } else {
                // 既存データの更新
                if let thawedMedicine = medicine.thaw() {
                    thawedMedicine.medicineName = medicineName
                    //                    thawedMedicine.effect = effect
                    thawedMedicine.memo = memo
                    thawedMedicine.secondTiming = selectedSecondTiming
                    
                    thawedMedicine.firstTiming.removeAll()
                    thawedMedicine.firstTiming.append(objectsIn: Array(selectedFirstTimings))
                    //                    thawedMedicine.toggleEffect = toggleEffect
                    thawedMedicine.toggleMemo = toggleMemo
                    
                    if let selectedUnit = selectedUnit {
                        thawedMedicine.unit = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
                    } else {
                        thawedMedicine.unit = nil
                    }
                    
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
                thawedMedicine.isUsing.toggle()
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
                
                // 関連する unit を削除（存在する場合）
                if let unit = medicineToDelete.unit {
                    realm.delete(unit)
                }
                
                // 関連する time（List）をすべて削除
                realm.delete(medicineToDelete.time)
                
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
