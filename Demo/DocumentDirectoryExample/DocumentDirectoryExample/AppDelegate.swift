//
//  AppDelegate.swift
//  DocumentDirectoryExample
//
//  Created by MBA0202 on 5/27/18.
//  Copyright © 2018 MBA0202. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        let navi = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = navi
        return true
    }

}

