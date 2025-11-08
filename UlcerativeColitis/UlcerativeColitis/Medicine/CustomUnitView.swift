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
        VStack {
            ForEach(unitArray, id: \.id) { unit in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(1.0))
                        .stroke(Color.black.opacity(0.5), lineWidth: 1.2)
                        .frame(height: 50)
                    HStack {
                        Text(unit.unitName)
                            .font(.system(size: 20))
                        Spacer()
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
                                Text("「\(unit.unitName)」を削除しますか？")
                            } else {
                                Text("この単位を削除しますか？")
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
            
            Button(action: {
                showAddAlert.toggle()
            }) {
                Text("カスタム")
                    .foregroundColor(.black)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 200, height: 40)
            )
            .alert("単位", isPresented: $showAddAlert) {
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
        .padding(.vertical)
        .background(Color.gray.opacity(0.1))
        .onAppear {
            print(UnitArray())
        }
    }
    
    private func addUnit() {
        let realm = try! Realm()
        
        try! realm.write {
            let model = UnitArray()
            model.unitName = newUnitTextField
            realm.add(model)
        }
        newUnitTextField = ""
    }
    
    private func deleteUnit(_ unit: UnitArray) {
        let realm = try! Realm()
        
        if let objectToDelete = realm.object(ofType: UnitArray.self, forPrimaryKey: unit.id) {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
}

#Preview {
    CustomUnitView(selectedUnit: .constant(UnitArray("錠")), onTap: {})
}
