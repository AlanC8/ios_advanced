import UIKit

class ImageLoader {
    weak var delegate: ImageLoaderDelegate?
    var completionHandler: ((UIImage?) -> Void)?
    
    func loadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.imageLoader(self, didFailWith: error)
                    self.completionHandler?(nil)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    self.delegate?.imageLoader(self, didLoad: image)
                    self.completionHandler?(image)
                }
            }
        }.resume()
    }
} 
