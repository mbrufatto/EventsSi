//
//  SceneDelegate.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navigationVC = UINavigationController()
        window?.rootViewController = navigationVC
        
        let networkManager = NetworkManager()
        let listEventViewModel = ListEventViewModel(networkManagerProtocol: networkManager)
        
        navigationVC.pushViewController(ListEventViewController(listEventViewModelProtocol: listEventViewModel), animated: false)
        window?.makeKeyAndVisible()
    }
}

