//
//  TabView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/04.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Int = 0
    
    @Binding var selectDay: Date
    
    init(selectDay: Binding<Date>) {
        self._selectDay = selectDay
        
        // UITabBarの背景を変更
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tag(0)
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
            
            MedicineListView()
                .tag(1)
                .tabItem {
                    Label("お薬情報", systemImage: "pills")
                }
            
            View1(selectDay: $selectDay)
                .tag(2)
                .tabItem {
                    Label("記録", systemImage: "pills")
                }
            AddTakingMedicineListView()
                .tag(3)
                .tabItem {
                    Label("記録", systemImage: "pills")
                }
            TakingMedicineListView(selectDay: $selectDay)
                .tag(4)
                .tabItem {
                    Label("記録", systemImage: "pills")
                }
        }
    }
}

//#Preview {
//    TabView()
//}
