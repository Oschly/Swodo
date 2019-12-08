//
//  SceneDelegate.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  private let notificationCenter = NotificationCenter.default
  
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let mainViewModel = MainViewModel()
    let mainView = TabBarView(mainViewModel: mainViewModel).environment(\.managedObjectContext, context)

    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: mainView)
        self.window = window
        window.makeKeyAndVisible()
    }
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    
    // Read state
    notificationCenter.post(name: .appIsGoingToForeground, object: nil)
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    notificationCenter.post(name: .appIsGoingToForeground, object: nil)
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
        notificationCenter.post(name: .appIsGoingToBackground, object: nil)
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    
    // Save state and data
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }

}

