//
//  SceneDelegate.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = ViewControllerComposer.composedWith()
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
}
