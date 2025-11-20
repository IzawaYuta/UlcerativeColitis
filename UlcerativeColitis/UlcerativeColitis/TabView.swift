//
//  TabView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/04.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Int = 0
    
    init() {
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
            
            View1()
                .tag(2)
                .tabItem {
                    Label("記録", systemImage: "pills")
                }
        }
    }
}

//#Preview {
//    TabView()
//}
