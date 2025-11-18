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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        addDefaultUnitsIfNeeded()
        IQKeyboardManager.shared.isEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            MainTabView()
            CalendarView2()
        }
    }
    
    private func addDefaultUnitsIfNeeded() {
        let realm = try! Realm()
        if realm.objects(UnitArray.self).isEmpty {
            try! realm.write {
                realm.add(UnitArray("錠"))
                realm.add(UnitArray("個"))
                realm.add(UnitArray("mg"))
            }
        }
    }
}
