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
    
    @State private var medicineName: String = ""
    @State private var dosage: Int = 0
    @State private var selectedFirstTimings: Set<FirstTiming> = []
    @State private var selectedSecondTiming: SecondTiming = .justBeforeMeals
    @State private var draftSecondTiming: SecondTiming = .justBeforeMeals
    @State private var effect: String = ""
    @State private var stock: String = ""
    @State private var memo: String = ""
    @State private var morningDosage: String = ""
    @State private var showPicker = false
    
    @State private var showCustomUnitView = false
    @State private var showStockUnitView = false //在庫単位選択用シート表示
    
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
                    if let selectedUnit = selectedUnit,
                       unitArray.contains(where: { $0.id == selectedUnit.id }) {
                        Text(selectedUnit.unitName)
                            .borderedTextStyle()
                    } else if let firstUnit = unitArray.first {
                        Text(firstUnit.unitName)  // 配列の最初を表示
                            .borderedTextStyle()
                    } else {
                        Text("-")  // 何もなければ "-"
                            .borderedTextStyle()
                    }
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
                            if let firstMedicine = medicineInfo.first {
                                Text(firstMedicine.secondTiming.japaneseText)
                                    .foregroundColor(.black)
                            } else {
                                Text(selectedSecondTiming.japaneseText)
                                    .foregroundColor(.black)
                            }
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
                                saveSecondTiming()
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
                                            TextField("", text: $morningDosage)
                                                .textFieldStyle(.roundedBorder)
                                                .multilineTextAlignment(.trailing)
                                                .frame(width: 100)
                                            if let selectedUnit = selectedUnit,
                                               unitArray.contains(where: { $0.id == selectedUnit.id }) {
                                                Text(selectedUnit.unitName)
                                            } else if let firstUnit = unitArray.first {
                                                Text(firstUnit.unitName)  // 配列の最初を表示
                                            } else {
                                                Text("-")  // 何もなければ "-"
                                            }
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
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(.gray)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("効果")
                    .font(.callout)
                TextEditor(text: $effect)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4))
                    )
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
                
                TextField("", text: $stock)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                
                Button(action: {
                    showStockUnitView.toggle()
                }) {
                    if let firstStockUnit = medicineInfo.first?.stockUnit.first?.unit.first {
                        Text(firstStockUnit.unitName)
                            .borderedTextStyle()
                    } else if let selectedStockUnit = selectedStockUnit,
                              unitArray.contains(where: { $0.id == selectedStockUnit.id }) {
                        Text(selectedStockUnit.unitName)
                            .borderedTextStyle()
                    } else if let selectedUnit = selectedUnit,
                              unitArray.contains(where: { $0.id == selectedUnit.id }) {
                        Text(selectedUnit.unitName)
                            .borderedTextStyle()
                    } else if let firstUnit = unitArray.first {
                        Text(firstUnit.unitName)
                            .borderedTextStyle()
                    } else {
                        Text("-")
                    }
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
            
            VStack(alignment: .leading) {
                Text("メモ")
                    .font(.callout)
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
//                        .foregroundColor(memo.isEmpty ? Color.gray.opacity(0.5) : Color.clear)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                    
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .onAppear {
            if let loadMedicineInfo = medicineInfo.first {
                selectedFirstTimings = Set(loadMedicineInfo.firstTiming)
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
}

#Preview {
    MedicineInfoView()
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
