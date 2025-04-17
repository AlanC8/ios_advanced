//
//  ContentView.swift
//  FiveImages
//
//  Created by Arman Myrzakanurov on 28.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ImagesViewModel = ImagesViewModel()

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.images) { model in
                                NavigationLink(destination: ImageDetailView(image: model.image)) {
                                    model.image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fill)
                                        .clipped()
                                        .cornerRadius(8)
                                        .onAppear {
                                            viewModel.loadMoreImagesIfNeeded(currentItem: model)
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                    .refreshable {
                        await Task {
                           viewModel.refreshImages()
                        }.value
                    }

                    if viewModel.isFetching && viewModel.images.isEmpty {
                        ProgressView("Loading...")
                    }
                }

                if viewModel.isFetching && !viewModel.images.isEmpty {
                    ProgressView()
                        .padding(.vertical, 5)
                }

                Button {
                    viewModel.getImages()
                } label: {
                    Text("Get 5 More Images")
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isFetching)
                .padding(.bottom)

            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Image Gallery")
            .alert(item: viewModel.errorMessageWrapper) { errorAlert in
                Alert(
                    title: Text("Error"),
                    message: Text(errorAlert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        } 
    }
}

#Preview {
    ContentView()
}
