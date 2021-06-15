//
//  SceneDelegate.swift
//  Fika
//
//  Created by Hanming on 14/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let hasOnboarded: Bool = UserRepository.readValue(forKey: "onboarded") {
            print(hasOnboarded) // To void the warning
            return
        }

        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
        self.window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let rootVC = storyboard.instantiateViewController(
                identifier: "Onboarding") as? OnboardingViewController else {
            print("ViewController not found")
            return
        }

        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
