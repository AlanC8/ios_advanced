import Foundation
import SwiftUI
import UIKit
import Combine


final class ImagesViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var errorMessage: String? = nil
    @Published var isFetching: Bool = false

    private var imageCache = NSCache<NSString, UIImage>()

    func getImages(count: Int = 5) {
        guard !isFetching else { return }
        isFetching = true
        errorMessage = nil

        let group = DispatchGroup()
        var downloadedImages: [ImageModel] = []
        var firstError: Error? = nil

        let urlStrings: [String] = (0..<count).map { _ in
            "https://picsum.photos/id/\(Int.random(in: 0...1000))/500"
        }

        for urlString in urlStrings {
            group.enter()
            downloadImage(urlString: urlString) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        downloadedImages.append(model)
                    case .failure(let error):
                        print("Download failed for \(urlString): \(error.localizedDescription)")
                        if firstError == nil {
                            firstError = error
                        }
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.images += downloadedImages
            if let error = firstError {
                self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
            self.isFetching = false
        }
    }

    func refreshImages() {
        guard !isFetching else { return }
        images.removeAll()
        errorMessage = nil
        getImages()
    }

    func loadMoreImagesIfNeeded(currentItem item: ImageModel?) {
        guard let item = item else {
            if images.isEmpty {
                getImages()
            }
            return
        }

        let thresholdIndex = images.index(images.endIndex, offsetBy: -3)
        if images.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            print("Approaching end of list, loading more...")
            getImages()
        }
    }

    private func downloadImage(urlString: String, completion: @escaping (Result<ImageModel, Error>) -> Void) {
        if let cachedUIImage = imageCache.object(forKey: urlString as NSString) {
            print("Using cached image for: \(urlString)")
            let model = ImageModel(image: Image(uiImage: cachedUIImage))
            completion(.success(model))
            return
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(ImageDownloadError.invalidURL))
            return
        }

        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(ImageDownloadError.networkError(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(ImageDownloadError.unexpectedResponse(statusCode: 0)))
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(ImageDownloadError.unexpectedResponse(statusCode: httpResponse.statusCode)))
                    return
                }

                guard let safeData = data else {
                    completion(.failure(ImageDownloadError.noData))
                    return
                }

                guard let uiImage = UIImage(data: safeData) else {
                    completion(.failure(ImageDownloadError.dataConversionError))
                    return
                }

                self.imageCache.setObject(uiImage, forKey: urlString as NSString)

                let model = ImageModel(image: Image(uiImage: uiImage))
                completion(.success(model))
            }
        }
        .resume()
    }
}

extension ImagesViewModel {
    var errorMessageWrapper: Binding<ErrorAlert?> {
        Binding<ErrorAlert?>(
            get: {
                guard let message = self.errorMessage else { return nil }
                return ErrorAlert(message: message)
            },
            set: { _ in
                self.errorMessage = nil
            }
        )
    }
}
