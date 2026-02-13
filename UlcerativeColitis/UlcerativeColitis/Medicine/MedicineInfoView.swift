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
//    @State private var selectedStockUnit: UnitArray? //在庫用単位の選択状態
    
    var isNewMedicine: Bool {
        medicine.realm == nil
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
                                                    }) {
                                                        Text(timing.japaneseText)
                                                            .font(.system(size: 17))
                                                    }
                                                    .frame(width: 60, height: 30)
                                                HStack {
                                                    dosageTextField(for: timing)
                                                        .frame(width: 100, height: 36)
                                                        .textFieldStyle(.roundedBorder)
                                                    
                                                    Text(getDosageUnitDisplayText())
//                                                    Text(getUnitDisplayText())
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
                                                }) {
                                                    Text(timing.japaneseText)
                                                        .font(.system(size: 17))
                                                }
                                                .frame(width: 100, height: 30)
                                        }
                                    }
                                    
                                }
                            }
                            
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
//                        Text(getDosageUnitDisplayText())
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
                    
                    HStack {
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
                        NotificationManager.instance.checkPendingNotifications()
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
                    stockText = medicine.stock.map { String($0) } ?? ""
                    memo = medicine.memo ?? ""
                    selectedSecondTiming = medicine.secondTiming
//                    if let existingUnit = medicine.unit {
                    selectedUnit = medicine.unit
//                    }
                    // 新規の場合はunitArrayの最初の要素を使用
//                    else {
//                        let defaultUnit = UnitArray(unit: .tablet)
//                        selectedUnit = defaultUnit
//                    }
                    tentativeTime = medicine.time.map { $0.time }
                    toggleMemo = medicine.toggleMemo
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button(role: .destructive) {
                                if !isNewMedicine {
                                    showDeleteAlert.toggle()
                                }
                            } label: {
                                Text("削除")
                            }
                            
                            if medicine.isUsing {
                                Button(action: {
                                    if !isNewMedicine {
                                        showIsUsingAlert.toggle()
                                    }
                                }) {
                                    Text("不使用にする")
                                }
                            } else {
                                Button(action: {
                                    if !isNewMedicine {
                                        showIsUsingAlert.toggle()
                                    }
                                }) {
                                    Text("使用中にする")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .alert("確認", isPresented: $showDeleteAlert) {
                            Button("キャンセル", role: .cancel) {}
                            Button("削除", role: .destructive) {
                                deleteMedicine(by: medicine.id)
                                dismiss()
                            }
                        } message: {
                            Text("「\(medicine.medicineName)」を削除しますか？")
                        }
                        .alert("確認", isPresented: $showIsUsingAlert) {
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
            .scrollBounceBehavior(.basedOnSize)
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
        }
    }
    
    //お薬保存メソッド
    private func saveMedicine() {
        let realm = try! Realm()
        var savedMedicineId: String = medicine.id  // デフォルトは既存のID
        
        try! realm.write {
            if isNewMedicine {
                // 新規作成
                let model = MedicineInfo()
                model.medicineName = medicineName
                model.memo = memo
                model.secondTiming = selectedSecondTiming
                model.firstTiming.append(objectsIn: Array(selectedFirstTimings))
                model.toggleMemo = toggleMemo
                
                if let selectedUnit = selectedUnit {
                    let unitCopy = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
                    model.unit = unitCopy
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
                savedMedicineId = model.id  // ← 新しいIDを保存
                print(model)
                medicineName = ""
                dosageText = ""
//                selectedUnit = nil
                selectedFirstTimings = []
                morningDosageText = ""
                noonDosageText = ""
                eveningDosageText = ""
                selectedSecondTiming = .justBeforeMeals
                effect = ""
                stockText = ""
                memo = ""
                //                tentativeTime = []
                toggleMemo = false
                
            } else {
                // 既存データの更新
                if let thawedMedicine = medicine.thaw() {
                    thawedMedicine.medicineName = medicineName
                    thawedMedicine.memo = memo
                    thawedMedicine.secondTiming = selectedSecondTiming
                    
                    thawedMedicine.firstTiming.removeAll()
                    thawedMedicine.firstTiming.append(objectsIn: Array(selectedFirstTimings))
                    thawedMedicine.toggleMemo = toggleMemo
                    
                    if let selectedUnit = selectedUnit {
                        let unitCopy = realm.create(UnitArray.self, value: selectedUnit, update: .modified)
                        thawedMedicine.unit = unitCopy
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
                    savedMedicineId = thawedMedicine.id
                    print(thawedMedicine)
                }
            }
        }
        
        saveTiming()
        
        // 使用中の場合のみ通知を設定
        let realm2 = try! Realm()
        if let savedMedicine = realm2.object(ofType: MedicineInfo.self, forPrimaryKey: savedMedicineId),
           savedMedicine.isUsing {
            scheduleNotification(medicineId: savedMedicineId)
        } else {
            print("不使用中のため、通知は設定されません")
        }
        
        if isNewMedicine {
            tentativeTime = []
        }
    }
    
    //FirstTiming切り替えメソッド
    private func toggle(_ timing: FirstTiming) {
        if selectedFirstTimings.contains(timing) {
            selectedFirstTimings.remove(timing)
        } else {
            selectedFirstTimings.insert(timing)
        }
    }
    
    //FirstTiming保存メソッド
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
    
    //SecondTiming保存メソッド
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
    
    //服用時間削除メソッド
    private func deleteTime(_ timeEntry: MedicineTime) {
        let realm = try! Realm()
        
        if let objectToDelete = realm.object(ofType: MedicineTime.self, forPrimaryKey: timeEntry.id) {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
    
    //使用不使用切り替え
    private func isUsingChange() {
        let realm = try! Realm()
        try! realm.write {
            if let thawedMedicine = medicine.thaw() {
                thawedMedicine.isUsing.toggle()
                
                // 不使用になったら通知をオフ
                if !thawedMedicine.isUsing {
                    print("「\(thawedMedicine.medicineName)」を不使用にしました")
                    cancelMedicineNotifications(medicineId: thawedMedicine.id)
                    print("通知をオフにしました")
                }
                // 使用中に戻したら通知を再設定
                else {
                    print("「\(thawedMedicine.medicineName)」を使用中にしました")
                    scheduleNotification(medicineId: thawedMedicine.id)
                }
            }
        }
        
        // 変更後の通知確認
        NotificationManager.instance.checkPendingNotifications()
    }
    
    //Timingのカラー
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
    
//    private func getStockUnitDisplayText() -> String {
//        if let firstMedicine = medicineInfo.first {
//            if let customName = firstMedicine.unit.customUnitName, !customName.isEmpty {
//                return customName
//            } else {
//                return firstMedicine.unit.unitName.japaneseText
//            }
//        } else {
//            // デフォルトは tablet
//            return UnitArrayEnum.tablet.japaneseText
//        }
//    }
    
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
    
//    private func getUnitDisplayText() -> String {
//        if let selectedUnit = selectedUnit,
//           unitArray.contains(where: { $0.id == selectedUnit.id }) {
//            return selectedUnit.unitName
//        } else if let firstUnit = unitArray.first {
//            return firstUnit.unitName
//        } else {
//            return "-"
//        }
//    }
    
    private func getDosageUnitDisplayText() -> String {
        // selectedUnitがnilの場合も考慮
        if let selectedUnit = selectedUnit,
           unitArray.contains(where: { $0.id == selectedUnit.id }) {
            if let customName = selectedUnit.customUnitName, !customName.isEmpty {
                return customName
            }
            if let unitName = selectedUnit.unitName?.japaneseText {
                return unitName
            }
        }
        
        if let firstUnit = unitArray.first {
            if let customName = firstUnit.customUnitName, !customName.isEmpty {
                return customName
            }
            if let unitName = firstUnit.unitName?.japaneseText {
                return unitName
            }
        }
        
        return UnitArrayEnum.tablet.japaneseText
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
        
        // 削除前の通知確認
        print("=== 削除前の通知確認 ===")
        NotificationManager.instance.checkPendingNotifications()
        
        try! realm.write {
            if let medicineToDelete = realm.object(ofType: MedicineInfo.self, forPrimaryKey: id) {
                
                print("削除する薬: \(medicineToDelete.medicineName) (ID: \(id))")
                print("削除する通知の数: \(medicineToDelete.time.count)件")
                
                // 関連する unit を削除（存在する場合）
                if let unit = medicineToDelete.unit {
                    realm.delete(unit)
                }
                
                // 関連する time（List）をすべて削除
                realm.delete(medicineToDelete.time)
                
                realm.delete(medicineToDelete)
            }
        }
        // 通知を削除
        cancelMedicineNotifications(medicineId: id)
        print("薬ID: \(id) の通知を削除しました")
        
        print("=== 削除後の通知確認 ===")
        NotificationManager.instance.checkPendingNotifications()
    }
    
    private func scheduleNotification(medicineId: String) {
        // この薬の既存の通知をすべてキャンセル
        cancelMedicineNotifications(medicineId: medicineId)
        
        // 保存された時間を取得
        let timesToSchedule: [Date]
        if !isNewMedicine && !medicine.time.isEmpty {
            // 既存の薬の場合、Realmから取得
            timesToSchedule = medicine.time.map { $0.time }
        } else if !tentativeTime.isEmpty {
            // 新規の場合、tentativeTimeから取得
            timesToSchedule = tentativeTime
        } else {
            // 時間が設定されていない場合は通知しない
            print("通知する時間が設定されていません")
            return
        }
        
        // 各時間に対して通知を設定
        for (index, notificationTime) in timesToSchedule.enumerated() {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: notificationTime)
            let minute = calendar.component(.minute, from: notificationTime)
            
            // 時間帯に応じたメッセージ（オプション）
            
            NotificationManager.instance.scheduleRepeatingNotification(
                title: "お薬",
                body: "\(medicineName) \(selectedSecondTiming.japaneseText)",
                hour: hour,
                minute: minute,
                identifier: "medicine_\(medicineId)_\(index)"
            )
        }
        
        print("\(medicineName)の通知を\(timesToSchedule.count)件設定しました")
    }
    
    // 特定の薬の通知をすべてキャンセル
    private func cancelMedicineNotifications(medicineId: String) {
        // 最大10件の通知をキャンセル（必要に応じて増やす）
        for index in 0..<10 {
            NotificationManager.instance.cancelNotification(
                identifier: "medicine_\(medicineId)_\(index)"
            )
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
