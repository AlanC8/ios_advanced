//
//  SceneDelegate.swift
//  final
//
//  Created by Алан Абзалханулы on 29.04.2025.
//

import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // 1. Глобальный router
        let router = AppRouter()
        
        // 2. Выбираем стартовый экран
        let rootVC: UIViewController
        if TokenStore.shared.accessToken != nil {
            // ─ Токен есть → сразу список машин
            rootVC = UIHostingController(rootView: MainTabView())
        } else {
            // ─ Нет токена → экран логина
            let loginVM = LoginViewModel(router: router)
            rootVC = UIHostingController(rootView: LoginView(vm: loginVM))
        }
        
        // 3. Навконтроллер
        
        let nav  = UINavigationController(rootViewController: rootVC)
        router.rootViewController = nav
        
        // 4. Окно
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
