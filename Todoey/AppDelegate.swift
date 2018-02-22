    //
//  AppDelegate.swift
//  Todoey
//
//  Created by Rajagopal Srinivasan on 2/20/18.
//  Copyright © 2018 Rajagopal Srinivasan. All rights reserved.
//

import UIKit
import RealmSwift
    

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        do {
            //let realm = try Realm()
            //Since realm is not used it is replaced with _
            
            _ = try Realm()
            
        } catch {
            print("Error in initializing Realm \(error)")
        }
        
        return true
    }

    
   


}

