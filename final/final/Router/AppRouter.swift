//
//  AppRouter.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import UIKit
import SwiftUI

@MainActor
class AppRouter {
    weak var rootViewController: UINavigationController?
    
    func navigateToSecondScreen() {
        let secondView = Text("🌟 Второй экран").font(.title)
        let vc = UIHostingController(rootView: secondView)
        rootViewController?.pushViewController(vc, animated: true)
    }
    func navigateToHome() {
        let vc = UIHostingController(rootView: CarListView())
        rootViewController?.setViewControllers([vc], animated: true)
    }
    func navigateToRegister() {
        let vm  = RegisterViewModel(router: self)
        let vc  = UIHostingController(rootView: RegisterView(vm: vm))
        rootViewController?.pushViewController(vc, animated: true)
    }
}
