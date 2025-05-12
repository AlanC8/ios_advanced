//
//  MainTabView.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CarListView()
                .tabItem { Label("Машины", systemImage: "car") }

            AddCarFlowView()
                .tabItem { Label("Добавить", systemImage: "plus.square.fill") }

            ProfileView()
                .tabItem { Label("Профиль", systemImage: "person") }
        }
    }
}
