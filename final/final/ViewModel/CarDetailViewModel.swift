//
//  CarDetailViewModel.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//


import Foundation

@MainActor
final class CarDetailViewModel: ObservableObject {
    // PUBLIC
    @Published var car: CarDetail?
    @Published var isFav = false
    @Published var loading = false
    @Published var alert: AlertItem?

    // PRIVATE
    private let id: String
    private let carService: CarService
    private let favService: FavoriteService

    init(
        id: String,
        carService: CarService = CarServiceImpl(),
        favService: FavoriteService = FavoriteServiceImpl()
    ) {
        self.id         = id
        self.carService = carService
        self.favService = favService
        Task { await load() }
    }

    /// переключаем избранное
    func toggleFavorite() {
        Task {
            do {
                try await favService.toggle(carID: id)
                isFav.toggle()
            } catch {
                alert = AlertItem(message: "Не удалось изменить избранное")
            }
        }
    }

    // MARK: – загрузка
    private func load() async {
        loading = true
        do { car = try await carService.fetchOne(id: id) }
        catch { alert = AlertItem(message: "Не удалось загрузить") }
        loading = false
    }
}

