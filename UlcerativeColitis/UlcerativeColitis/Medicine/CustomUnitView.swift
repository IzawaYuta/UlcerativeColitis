//
//  CustomUnitView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/03.
//

import SwiftUI
import RealmSwift

struct CustomUnitView: View {
    
    @ObservedResults(UnitArray.self) var unitArray
    
    @State private var showAddAlert = false
    @State private var showDeleteAlert = false
    @State private var newUnitTextField = ""
    
    @State private var unitToDelete: UnitArray?
    
    @Binding var selectedUnit: UnitArray?
    
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            VStack {
                ForEach(unitArray, id: \.id) { unit in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.5), lineWidth: 1.2)
                            )
                            .frame(height: 50)
                        
                        HStack {
                            // unitName または customUnitName のどちらかを表示
                            Text(unit.customUnitName ?? unit.unitName?.japaneseText ?? "-")
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            // カスタム単位の場合のみ削除ボタンを表示
                            if unit.customUnitName != nil {
                                Button(action: {
                                    unitToDelete = unit
                                    showDeleteAlert.toggle()
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red.opacity(0.5))
                                        .font(.system(size: 13))
                                }
                                .alert("", isPresented: $showDeleteAlert) {
                                    Button("キャンセル", role: .cancel) {}
                                    Button("削除", role: .destructive) {
                                        if let unit = unitToDelete {
                                            deleteUnit(unit)
                                        }
                                    }
                                } message: {
                                    if let unit = unitToDelete {
                                        Text("「\(unit.customUnitName ?? "")」を削除しますか？")
                                    } else {
                                        Text("この単位を削除しますか？")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedUnit = unit
                        onTap()
                    }
                }
                
                // カスタム追加ボタン
                Button(action: {
                    showAddAlert.toggle()
                }) {
                    Text("カスタム")
                        .foregroundColor(.black)
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.5))
                        )
                }
                .alert("単位を追加", isPresented: $showAddAlert) {
                    TextField("個、mg", text: $newUnitTextField)
                    Button("キャンセル", role: .cancel) {
                        newUnitTextField = ""
                    }
                    Button(action: {
                        addUnit()
                    }) {
                        Text("保存")
                    }
                    .disabled(newUnitTextField.isEmpty)
                }
                .padding(.vertical)
                
                Spacer()
            }
        }
    }
    
    private func addUnit() {
        guard let realm = try? Realm() else {
            print("❌ Realmの初期化に失敗")
            return
        }
        
        do {
            try realm.write {
                let model = UnitArray()
                model.customUnitName = newUnitTextField
                realm.add(model)
                
                print("\n=== カスタム単位を追加 ===")
                print("追加した単位: customUnitName=\(model.customUnitName ?? "nil"), id=\(model.id)")
            }
            
            // 追加後の全件表示
            print("\n=== 追加後の全UnitArray ===")
            let allUnits = realm.objects(UnitArray.self)
            for (index, unit) in allUnits.enumerated() {
                print("[\(index)] unitName=\(unit.unitName?.japaneseText ?? "nil"), customUnitName=\(unit.customUnitName ?? "nil")")
            }
            print("合計: \(allUnits.count)件\n")
            
            newUnitTextField = ""
        } catch {
            print("❌ カスタム単位の追加に失敗: \(error)")
        }
    }
    
    private func deleteUnit(_ unit: UnitArray) {
        guard let realm = try? Realm() else {
            print("❌ Realmの初期化に失敗")
            return
        }
        
        if let objectToDelete = realm.object(ofType: UnitArray.self, forPrimaryKey: unit.id) {
            do {
                print("\n=== カスタム単位を削除 ===")
                print("削除する単位: unitName=\(objectToDelete.unitName?.japaneseText ?? "nil"), customUnitName=\(objectToDelete.customUnitName ?? "nil"), id=\(objectToDelete.id)")
                
                try realm.write {
                    realm.delete(objectToDelete)
                }
                
                // 削除後の全件表示
                print("\n=== 削除後の全UnitArray ===")
                let allUnits = realm.objects(UnitArray.self)
                for (index, unit) in allUnits.enumerated() {
                    print("[\(index)] unitName=\(unit.unitName?.japaneseText ?? "nil"), customUnitName=\(unit.customUnitName ?? "nil")")
                }
                print("合計: \(allUnits.count)件\n")
                
            } catch {
                print("❌ カスタム単位の削除に失敗: \(error)")
            }
        } else {
            print("⚠️ 削除対象の単位が見つかりません: id=\(unit.id)")
        }
    }
}

#Preview {
    CustomUnitView(selectedUnit: .constant(UnitArray(unit: .tablet)), onTap: {})
}
