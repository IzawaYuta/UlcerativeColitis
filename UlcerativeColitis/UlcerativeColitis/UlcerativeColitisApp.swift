//
//  TestApp.swift
//  Test
//
//  Created by Engineer MacBook Air on 2025/10/16.
//

import SwiftUI
import RealmSwift
import IQKeyboardManagerSwift

@main
struct UlcerativeColitisApp: App {
    
    @State private var selectDay: Date = Date()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        initializePresetUnits()
        IQKeyboardManager.shared.isEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            //            ContentView()
            MainTabView(selectDay: $selectDay)
            //            CalendarView2(selectDay: $selectDay)
        }
    }
    
    private func initializePresetUnits() {
        guard let realm = try? Realm() else { return }
        
        let existingPresets = realm.objects(UnitArray.self).filter("unitName != nil")
        
        if existingPresets.isEmpty {
            do {
                try realm.write {
                    for unitEnum in UnitArrayEnum.allCases {
                        let unit = UnitArray(unit: unitEnum)
                        realm.add(unit)
                        
                        // 追加した単位を出力
                        print("追加: unitName=\(unit.unitName?.rawValue ?? "nil"), japaneseText=\(unit.unitName?.japaneseText ?? "nil")")
                    }
                }
                print("✅ プリセット単位を初期化しました")
                
                // 初期化後の全件確認
                print("\n=== 初期化後の全UnitArray ===")
                let allUnits = realm.objects(UnitArray.self)
                for (index, unit) in allUnits.enumerated() {
                    print("[\(index)] id=\(unit.id)")
                    print("    unitName=\(unit.unitName?.rawValue ?? "nil")")
                    print("    japaneseText=\(unit.unitName?.japaneseText ?? "nil")")
                    print("    customUnitName=\(unit.customUnitName ?? "nil")")
                }
                print("合計: \(allUnits.count)件\n")
                
            } catch {
                print("❌ プリセット単位の初期化に失敗: \(error)")
            }
        } else {
            print("⚠️ プリセット単位は既に初期化済みです")
            
            // 既存の全件確認
            print("\n=== 既存の全UnitArray ===")
            let allUnits = realm.objects(UnitArray.self)
            for (index, unit) in allUnits.enumerated() {
                print("[\(index)] id=\(unit.id)")
                print("    unitName=\(unit.unitName?.rawValue ?? "nil")")
                print("    japaneseText=\(unit.unitName?.japaneseText ?? "nil")")
                print("    customUnitName=\(unit.customUnitName ?? "nil")")
            }
            print("合計: \(allUnits.count)件\n")
        }
    }
}
