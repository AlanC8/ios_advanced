//
//  CarListView.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import SwiftUI

struct CarListView: View {
    @StateObject private var vm      = CarListViewModel()
    @State private var showFilter    = false

    var body: some View {
        NavigationStack {
            List {
                // ─ Объявления
                ForEach(vm.visible) { car in
                    NavigationLink {
                        CarDetailView(id: car.id)
                    } label: {
                        CarRowView(
                            car: car,
                            tapFavorite: { vm.toggleFavorite(id: car.id) }
                        )
                    }
                    .onAppear { vm.loadNextIfNeeded(current: car) }
                }

                if vm.loading {
                    HStack { Spacer(); ProgressView(); Spacer() }
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await vm.reload()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // левый заголовок
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Wheelix")
                        .font(.montserrat(.bold, size: 20))
                }
                // правая кнопка «Фильтр»
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Фильтр") { showFilter = true }
                }
            }
            .sheet(isPresented: $showFilter) {
                FilterSheet(filter: $vm.filter)
                    .presentationDetents([.medium, .large])
            }
            .onAppear { vm.initialLoad() }
            .alert(item: $vm.alert) { alert in
                Alert(title: Text(alert.message))
            }
        }
    }
}

#Preview { CarListView() }
