//
//  FilterSheet.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct FilterSheet: View {
    @Binding var filter: CarFilter

    // локальные состояния
    @State private var minMileage = ""
    @State private var maxMileage = ""
    @State private var showBrand  = false

    var body: some View {
        NavigationStack {
            Form {

                // ─── Марка, модель ───────────────────────────────
                Section {
                    HStack {
                        Text("Марка, модель")
                        Spacer()
                        if let id = filter.brandID {
                            Text(BrandCache.shared.name(for: id) ?? "—")
                                .foregroundColor(.accent)
                        }
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { showBrand = true }
                }

                // ─── Состояние (новые / б/у) ─────────────────────
                Picker("Состояние", selection: $filter.isNew) {
                    Text("Все").tag(Bool?.none)
                    Text("Новые").tag(Bool?.some(true))
                    Text("С пробегом").tag(Bool?.some(false))
                }
                .pickerStyle(.segmented)

                // ─── Пробег ─────────────────────────────────────
                Section("Пробег, км") {
                    HStack {
                        TextField("от", text: $minMileage)
                        Text("—")
                        TextField("до", text: $maxMileage)
                    }
                    .keyboardType(.numberPad)
                    .onChange(of: minMileage) { filter.minMileage = Int($0) }
                    .onChange(of: maxMileage)  { filter.maxMileage = Int($0) }
                }
            }
            .navigationTitle("Фильтр")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Сброс")  { reset() }
                }
            }
            .sheet(isPresented: $showBrand) {
                BrandPickerSheet { brandID, seriesID, genID in
                    filter.brandID      = brandID
                    filter.seriesID     = seriesID
                    filter.generationID = genID
                }
            }
        }
    }

    // MARK: helpers
    @Environment(\.dismiss) private var dismiss
    private func reset() {
        filter = CarFilter()    // полное обнуление
        minMileage = ""; maxMileage = ""
    }
}

/* ──────────────────────────────────────────────────────────────
   BrandCache – чтобы быстро узнать имя марки по id для вывода
   ────────────────────────────────────────────────────────────── */
final class BrandCache {
    static let shared = BrandCache()
    private init() {}
    private var dict = [String: String]()

    func store(_ brands: [Brand]) {
        brands.forEach { dict[$0.id] = $0.name }
    }
    func name(for id: String) -> String? { dict[id] }
}
