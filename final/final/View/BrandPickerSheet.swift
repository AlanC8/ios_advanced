//
//  BrandPickerSheet.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//

import SwiftUI

// MARK: helpers (глобально) ─────────────────────────────
protocol Nameable { var name: String { get } }
extension Brand:  Nameable {}
extension Series: Nameable {}

// MARK: View ────────────────────────────────────────────
struct BrandPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = VM()
    
    var onSelect: (_ brandID: String?, _ seriesID: String?, _ genID: String?) -> Void
    
    private let twoCols   = Array(repeating: GridItem(.flexible()), count: 2)
    private let threeCols = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            Group {
                /* ───────────────── STEP 1  Марки ───────────────── */
                if vm.selectedBrand == nil {
                    ScrollView {
                        grid(vm.brands) { vm.tap(.brand($0)) }
                    }
                    .navigationTitle("Марка")
                    
                    /* ───────────────── STEP 2  Серии ───────────────── */
                } else if vm.selectedSeries == nil {
                    ScrollView {
                        grid(vm.series) { vm.tap(.series($0)) }
                    }
                    .navigationTitle(vm.selectedBrand!.name)
                }
            }
            /* ──────────────── STEP 3  Поколения ──────────────── */
            .navigationDestination(for: VM.Nav.self) { nav in
                if case .series(let s) = nav {
                    ScrollView {
                        LazyVGrid(columns: threeCols, spacing: 12) {
                            ForEach(s.generations) { gen in
                                Button {
                                    onSelect(vm.selectedBrand?.id, s.id, gen.id)
                                    dismiss()
                                } label: {
                                    Text(gen.code)
                                        .font(.montserrat(.medium, size: 14))
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle(s.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
        .task { await vm.loadBrands() }
        .alert(item: $vm.alert) { Alert(title: Text($0.message)) }
    }
    
    // универсальный grid-билдер (2 колонки)
    @ViewBuilder
    private func grid<T: Identifiable & Nameable>(_ items: [T],
                                                  tap: @escaping (T) -> Void) -> some View {
        LazyVGrid(columns: twoCols, spacing: 16) {
            ForEach(items) { item in
                Button { tap(item) } label: {
                    Text(item.name)
                        .font(.montserrat(.medium, size: 16))
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding()
    }
}

// MARK: View-Model ──────────────────────────────────────
@MainActor
extension BrandPickerSheet {
    final class VM: ObservableObject {
        
        enum Nav: Hashable { case series(Series) }
        @Published var path: [Nav] = []
        
        @Published var brands: [Brand] = []
        @Published var series: [Series] = []
        
        @Published var selectedBrand: Brand?
        @Published var selectedSeries: Series?
        @Published var alert: AlertItem?
        
        private let service: BrandService = BrandServiceImpl()
        
        func loadBrands() async {
            do {
                brands = try await service.fetchBrands()
                BrandCache.shared.store(brands)           // кэш имён
            } catch {
                alert = .init(message: "Не удалось загрузить марки")
            }
        }
        
        enum TapItem { case brand(Brand), series(Series) }
        
        func tap(_ item: TapItem) {
            switch item {
            case .brand(let b):
                selectedBrand = b
                Task {
                    do { series = try await service.fetchSeries(for: b.id) }
                    catch { alert = .init(message: "Нет серий") }
                }
            case .series(let s):
                selectedSeries = s
                path.append(.series(s))                  // переход к поколениям
            }
        }
    }}
