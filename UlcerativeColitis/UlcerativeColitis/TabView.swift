//
//  TabView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/04.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {   // ← $ が必要
            ContentView()
                .tag(0)
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
            
            MedicineInfoView(medicine: MedicineInfo())
                .tag(1)
                .tabItem {
                    Label("お薬情報", systemImage: "pills")
                }
            
            MedicineListView()
                .tag(2)
                .tabItem {
                    Label("お薬情報", systemImage: "pills")
                }
        }
    }
}

//#Preview {
//    TabView()
//}
