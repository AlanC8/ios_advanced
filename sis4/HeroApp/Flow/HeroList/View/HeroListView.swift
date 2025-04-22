import SwiftUI

struct HeroListView: View {
    @StateObject var viewModel: HeroListViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                content
            }
            .navigationBarHidden(true)
        }
        .task { await viewModel.fetchHeroes() }
    }

    private var searchBar: some View {
        TextField("Search hero…", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding()
    }

    @ViewBuilder private var content: some View {
        if viewModel.isLoading {
            ProgressView().frame(maxHeight: .infinity)
        } else if let err = viewModel.error {
            Text(err).foregroundColor(.red).frame(maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.heroes) { m in
                        HeroCard(m)
                            .onTapGesture { viewModel.routeToDetail(by: m.id) }
                    }
                }
                .padding(.vertical)
            }
        }
    }

    
    @ViewBuilder
    private func HeroCard(_ m: HeroListModel) -> some View {
        HStack(spacing: 16) {
            AsyncImage(url: m.image) { phase in
                if case .success(let img) = phase {
                    img.resizable().aspectRatio(contentMode: .fill)
                } else { Color.gray.opacity(0.2) }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(m.title).font(.headline)
                Text(m.subtitle).font(.subheadline).foregroundColor(.secondary)
                Text(m.publisher)
                    .font(.caption2)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.blue.opacity(0.12))
                    .cornerRadius(4)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
