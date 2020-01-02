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
  var window: UIWindow?

  var mainViewModel = MainViewModel()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let mainView = TabBarView(mainViewModel: mainViewModel).environment(\.managedObjectContext, context)

    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: mainView)
        self.window = window
        window.makeKeyAndVisible()
    }
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    mainViewModel.saveSession()
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    mainViewModel.readUnfinishedSession()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    
    // Save state and data
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }

}

