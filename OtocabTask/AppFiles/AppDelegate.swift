//
//  AppDelegate.swift
//  OtocabTask
//
//  Created by MGoKu on 5/5/20.
//  Copyright © 2020 MohammedBadr. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyAAZoxKZu6S9KjEpHj9kel35T_GJKCSn-s")
        GMSPlacesClient.provideAPIKey("AIzaSyAAZoxKZu6S9KjEpHj9kel35T_GJKCSn-s")
        
        return true
    }



}

