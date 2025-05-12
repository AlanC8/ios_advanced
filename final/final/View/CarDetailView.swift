//
//  CarDetailView.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct CarDetailView: View {
    @StateObject private var vm: CarDetailViewModel
    
    init(id: String) {
        _vm = StateObject(wrappedValue: CarDetailViewModel(id: id))
    }
    
    // MARK: body
    var body: some View {
        Group {
            if let car = vm.car { content(for: car) }
            else if vm.loading  { ProgressView() }
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { favButton }
        .alert(item: $vm.alert) { Alert(title: Text($0.message)) }
    }
}

// MARK: - Private UI helpers
private extension CarDetailView {
    
    /// основной контент
    @ViewBuilder
    func content(for c: CarDetail) -> some View {
        ScrollView {
            gallery(c.photos)
            
            VStack(alignment: .leading, spacing: 16) {
                priceBlock(c)
                infoTags(c)
                Divider()
                specs(c)
                descriptionBlock(c)
            }
            .padding()
        }
    }
    
    // --- gallery
    @ViewBuilder
    func gallery(_ photos: [String]) -> some View {
        TabView {
            ForEach(photos, id: \.self) { url in
                AsyncImage(url: URL(string: url)) { phase in
                    if let img = phase.image { img.resizable().scaledToFill() }
                    else { Color.gray.opacity(0.2) }
                }
                .frame(height: 260)
                .clipped()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: photos.count > 1 ? .automatic : .never))
        .frame(height: 260)
    }
    
    // --- price + title
    @ViewBuilder
    func priceBlock(_ c: CarDetail) -> some View {
        Text("\(c.price.formatted(.number.grouping(.automatic))) \(c.currency)")
            .font(.montserrat(.bold, size: 24))
            .foregroundColor(.accent)
        Text(c.title)
            .font(.montserrat(.semiBold, size: 20))
    }
    
    // --- gray tags
    @ViewBuilder
    func infoTags(_ c: CarDetail) -> some View {
        HStack(spacing: 12) {
            tag("\(c.year) г.")
            tag("\(c.mileage.formatted()) км")
            tag(c.city)
        }
    }
    
    func tag(_ text: String) -> some View {
        Text(text)
            .font(.montserrat(.light, size: 13))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .cornerRadius(6)
    }
    
    // --- specs
    @ViewBuilder
    func specs(_ c: CarDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            specRow("Двигатель", "\(c.engine.volume)L \(c.engine.type)")
            specRow("КПП", c.gearbox)
            specRow("Привод", c.drive.uppercased())
        }
    }
    
    func specRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).font(.montserrat(.light, size: 14))
            Spacer()
            Text(value).font(.montserrat(.medium, size: 14))
        }
    }
    
    // --- description
    @ViewBuilder
    func descriptionBlock(_ c: CarDetail) -> some View {
        if !c.description.isEmpty {
            Divider()
            Text(c.description)
                .font(.montserrat(.light, size: 15))
        }
    }
    
    // --- favourite button
    var favButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { vm.toggleFavorite() } label: {
                Image(systemName: vm.isFav ? "heart.fill" : "heart")
                    .font(.system(size: 20))
            }
        }
    }
}

#Preview { CarDetailView(id: "demo") }
