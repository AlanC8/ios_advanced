//
//  HomeView.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
            Text("🏠 Главная страница")
                .font(.largeTitle)
    }
}

#Preview {
    let dummyRouter = AppRouter()
    let dummyViewModel = HomeViewModel(router: dummyRouter)
    return HomeView(viewModel: dummyViewModel)
}
