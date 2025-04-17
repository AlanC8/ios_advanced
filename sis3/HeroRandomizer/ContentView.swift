//
//  ContentView.swift
//  HeroRandomizer
//
//  Created by Arman Myrzakanurov on 28.02.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: viewModel.selectedHero?.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                            .frame(height: 300)
                            .cornerRadius(15)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .infinity)
                            .cornerRadius(15)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .frame(height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.horizontal)
                
                if let hero = viewModel.selectedHero {
                    VStack(spacing: 16) {
                        Text(hero.name)
                            .font(.title)
                            .bold()
                        
                        InfoSection(title: "Basic Info") {
                            InfoRow(title: "Full Name", value: hero.biography.fullName)
                            InfoRow(title: "Gender", value: hero.appearance.gender)
                            InfoRow(title: "Race", value: hero.appearance.race ?? "Unknown")
                            InfoRow(title: "Publisher", value: hero.biography.publisher ?? "Unknown")
                        }
                        
                        InfoSection(title: "Power Stats") {
                            PowerStatsView(powerstats: hero.powerstats)
                        }
                        
                        InfoSection(title: "Work") {
                            InfoRow(title: "Occupation", value: hero.work.occupation)
                            InfoRow(title: "Base", value: hero.work.base)
                        }
                        
                        InfoSection(title: "Physical Characteristics") {
                            InfoRow(title: "Height", value: hero.appearance.height.last ?? "Unknown")
                            InfoRow(title: "Weight", value: hero.appearance.weight.last ?? "Unknown")
                        }
                    }
                    .padding()
                }
                
                Button {
                    Task {
                        await viewModel.fetchHero()
                    }
                } label: {
                    Text("Roll New Hero")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .task {
            if viewModel.selectedHero == nil {
                await viewModel.fetchHero()
            }
        }
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
            
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct PowerStatsView: View {
    let powerstats: Hero.Powerstats
    
    var body: some View {
        VStack(spacing: 8) {
            PowerStatRow(title: "Intelligence", value: powerstats.intelligence)
            PowerStatRow(title: "Strength", value: powerstats.strength)
            PowerStatRow(title: "Speed", value: powerstats.speed)
            PowerStatRow(title: "Durability", value: powerstats.durability)
            PowerStatRow(title: "Power", value: powerstats.power)
            PowerStatRow(title: "Combat", value: powerstats.combat)
        }
    }
}

struct PowerStatRow: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(title)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(value)")
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 4)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * CGFloat(value) / 100, height: 4)
                        .foregroundColor(Color.blue)
                }
            }
            .frame(height: 4)
        }
    }
}

#Preview {
    let viewModel = ViewModel()
    ContentView(viewModel: viewModel)
}
