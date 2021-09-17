//
//  AppDelegate.swift
//  FCWCDBSwiftDemo
//
//  Created by 肖志斌 on 2021/9/14.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()

        let vc  = ViewController()
        let nav = UINavigationController.init(rootViewController:vc)
        self.window?.rootViewController =  nav
        return true
    }
}

