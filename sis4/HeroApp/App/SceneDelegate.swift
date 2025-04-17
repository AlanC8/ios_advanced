//
//  SceneDelegate.swift
//  HeroApp
//
//  Created by Arman Myrzakanurov on 14.03.2025.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let winScene = scene as? UIWindowScene else { return }
        
        let service = HeroServiceImpl()
        let router  = HeroRouter()
        
        let listVM  = HeroListViewModel(service: service, router: router)
        let listVC  = UIHostingController(rootView: HeroListView(viewModel: listVM))
        let nav     = UINavigationController(rootViewController: listVC)
        
        router.rootViewController = nav
        
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
