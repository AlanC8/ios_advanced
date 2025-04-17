import SwiftUI

struct HeroDetailView: View {
    @StateObject var viewModel: HeroDetailViewModel

    var body: some View {
        ScrollView {
            switch (viewModel.isLoading, viewModel.error, viewModel.model) {
            case (true, _, _):
                ProgressView("Loading…").padding(.vertical, 120)
            case (_, let err?, _):
                Text(err).foregroundColor(.red).padding(.vertical, 120)
            case (_, _, let m?):
                content(m)
            default:
                EmptyView()
            }
        }
        .navigationTitle(viewModel.model?.name ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }

    private func content(_ m: HeroDetailModel) -> some View {
        VStack(spacing: 24) {
            AsyncImage(url: m.image) { phase in
                if case .success(let img) = phase {
                    img.resizable().aspectRatio(contentMode: .fit)
                } else { Color.gray.opacity(0.2) }
            }
            .frame(maxWidth: .infinity).cornerRadius(16)

            Text(m.fullName.isEmpty ? m.name : m.fullName)
                .font(.title).bold()

            section("Power Stats") {
                ForEach(m.power) { s in
                    HStack { Text(s.title); Spacer(); Text("\(s.value)") }
                }
            }

            section("Biography") {
                ForEach(m.bio) { r in row(r) }
            }

            section("Work & Base") {
                ForEach(m.work) { r in row(r) }
            }
        }
        .padding()
    }

    @ViewBuilder private func section<T: View>(_ title: String, @ViewBuilder _ content: () -> T) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(_ r: HeroDetailModel.Row) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(r.title).font(.caption).foregroundColor(.secondary)
            Text(r.value)
        }
    }
}
