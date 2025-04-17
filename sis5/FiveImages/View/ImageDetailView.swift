import SwiftUI

struct ImageDetailView: View {
    let image: Image

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .navigationTitle("Detail")
                .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

#Preview {
    NavigationView {
        ImageDetailView(image: Image(systemName: "photo"))
    }
} 
