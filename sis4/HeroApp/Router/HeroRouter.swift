import UIKit
import SwiftUI


@MainActor
final class HeroRouter {
    weak var rootViewController: UINavigationController?

    func showDetails(for id: Int) {
        let service = HeroServiceImpl()
        let vm      = HeroDetailViewModel(heroId: id, service: service)
        let view    = HeroDetailView(viewModel: vm)
        let vc      = UIHostingController(rootView: view)
        rootViewController?.pushViewController(vc, animated: true)
    }
}
