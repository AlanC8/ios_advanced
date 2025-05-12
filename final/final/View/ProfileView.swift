//
//  ProfileView.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var vm = VM()

    var body: some View {
        NavigationStack {
            ScrollView {
                // ─── ШАПКА ──────────────────────────────────────
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: vm.user?.avatar ?? "")) { phase in
                        if let img = phase.image {
                            img.resizable().scaledToFill()
                        } else {
                            Circle().fill(Color(.systemGray5))
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accent, lineWidth: 2))

                    Text(vm.user?.username ?? "—")
                        .font(.title3.weight(.semibold))

                    if let city = vm.user?.city {
                        Text(city).foregroundColor(.gray)
                    }

                    Text(vm.user?.email ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.top, 24)

                // ─── ИЗБРАННЫЕ ────────────────────────────────
                if !vm.favs.isEmpty {
                    Text("Избранное")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(vm.favs) { fav in
                            NavigationLink {
                                CarDetailView(id: fav.car.id)
                            } label: {
                                CarRowTile(car: fav.car)   // мини-тайл 2:1
                            }
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("У вас пока нет избранных объявлений")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                }
            }
            .refreshable { await vm.load() }
            .task { await vm.load() }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { /* открыть настройки, если нужны */ } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .alert(item: $vm.alert) { Alert(title: Text($0.message)) }
        }
    }
}

// ─── маленькая плитка машины  — ширина Flexible, высота 180 ────────────────
private struct CarRowTile: View {
    let car: Car
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: URL(string: car.photos.first ?? "")) { phase in
                if let img = phase.image { img.resizable().scaledToFill() }
                else { Color.gray.opacity(0.2) }
            }
            .frame(height: 110)
            .clipped()
            .cornerRadius(8)

            Text("\(car.price.formatted(.number.grouping(.automatic))) \(car.currency)")
                .font(.montserrat(.semiBold, size: 14))
                .foregroundColor(.accent)

            Text(car.title)
                .font(.montserrat(.light, size: 12))
                .lineLimit(1)
                .foregroundColor(.text)
        }
    }
}

/*────────────────────────  View-Model  ───────────────────────*/
@MainActor
extension ProfileView {
final class VM: ObservableObject {
    @Published var user: Me?
    @Published var favs: [Favorite] = []
    @Published var alert: AlertItem?

    private let client = HTTPClient.shared

    func load() async {
        do {
            async let me  : Me        = client.getJSON(endpoint: "auth/me")
            async let list: [Favorite] = client.getJSON(endpoint: "cars/me/favorites")
            user = try await me
            favs = try await list
        } catch {
            alert = .init(message: "Не удалось загрузить профиль")
        }
    }
}}

/*────────────────────────  DTO  ─────────────────────────────*/
struct Me: Decodable {
    let username: String
    let email: String
    let city: String?
    let avatar: String?
}

struct Favorite: Decodable, Identifiable {
    let id: String
    let car: Car
    private enum CodingKeys: String, CodingKey { case id = "_id", car }
}
