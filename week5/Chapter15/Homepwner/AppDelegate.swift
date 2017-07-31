//
//  AppDelegate.swift
//  Homepwner
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let itemStore = ItemStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(#function)    // 심화 학습
        
        let imageStore = ImageStore()
        
        let navController = window!.rootViewController as! UINavigationController
        let itemsController = navController.topViewController as! ItemsViewController
        
        itemsController.itemStore = itemStore
        itemsController.imageStore = imageStore
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        print(#function)    // 심화 학습
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print(#function)    // 심화 학습
        
        itemStore.saveChanges()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        print(#function)    // 심화 학습
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print(#function)    // 심화 학습
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        print(#function)    // 심화 학습
        
    }

}
