//
//  CarListViewModel.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import Foundation
import Combine

// MARK: - ViewModel

@MainActor
final class CarListViewModel: ObservableObject {
    
    // PUBLIC ---------------------------
    @Published var visible: [Car] = []          // что видит список
    @Published var filter  = CarFilter()        // бренд, пробег, isNew
    @Published var loading = false
    @Published var alert: AlertItem?
    
    // PRIVATE --------------------------
    private var all: [Car] = []                 // «сырые» машины с сервера
    private var page          = 1
    private var finishing     = false
    private let pageSize      = 20
    private var bag = Set<AnyCancellable>()
    
    private let carService: CarService
    private let favService: FavoriteService
    
    // MARK: init
    init(
        car: CarService = CarServiceImpl(),
        fav: FavoriteService = FavoriteServiceImpl()
    ) {
        self.carService = car
        self.favService = fav
        
        // обновлять results, когда пользователь меняет фильтр
        $filter
            .dropFirst()
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.applyLocalFilter() }
            .store(in: &bag)
    }
    
    // MARK: Public API
    
    /// начальная загрузка
    func initialLoad() {
        guard all.isEmpty else { return }
        Task { await loadPage(reset: true) }
    }
    
    /// подгрузка следующей страницы (при достижении конца списка)
    func loadNextIfNeeded(current car: Car) {
        guard car.id == visible.last?.id,
              !loading, !finishing else { return }
        page += 1
        Task { await loadPage() }
    }
    
    /// избранное
    func toggleFavorite(id: String) {
        Task { try? await favService.toggle(carID: id) }
    }
    
    // MARK: - PRIVATE LOADING
    
    private func loadPage(reset: Bool = false) async {
        loading = true
        do {
            // 1) Делаем копию фильтра и ставим актуальный page
            var pageFilter = filter
            pageFilter.page = page
            
            // 2) Запрашиваем страницу
            let resp = try await carService.fetch(filter: pageFilter)
            
            // 3) Обновляем данные
            if reset { all = resp.docs } else { all += resp.docs }
            if resp.docs.isEmpty { finishing = true }
            
            applyLocalFilter()
        } catch {
            alert = .init(message: "Ошибка загрузки")
        }
        loading = false
    }
    func reload() async {
        finishing = false
        filter.page = 1
        await loadPage(reset: true)
    }
    
    
    private func applyLocalFilter() {
        visible = all.filter { car in
            // brand
            if let b = filter.brandID,      car.brand       != b { return false }
            if let s = filter.seriesID,     car.series      != s { return false }
            if let g = filter.generationID, car.generation  != g { return false }
            
            if let min = filter.minMileage, car.mileage < min { return false }
            if let max = filter.maxMileage, car.mileage > max { return false }
            
            if let newState = filter.isNew {
                let isNewCar = car.mileage == 0
                if isNewCar != newState { return false }
            }
            return true
        }
    }
}

// MARK: - Helpers / Extensions

private extension CarService {
    /// Тот же filter, но только с номером страницы; бренд/пробег на сервер не уходит
    func fetch(_ filterWithPage: CarFilter) async throws -> CarListResponse {
        try await fetch(filter: filterWithPage)
    }
}
