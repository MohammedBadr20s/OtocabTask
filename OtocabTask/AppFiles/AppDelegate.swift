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
        GMSServices.provideAPIKey("AIzaSyAMReVdaPSQzndlRxBqr5wsUyOe5M6av-w")
        GMSPlacesClient.provideAPIKey("AIzaSyAMReVdaPSQzndlRxBqr5wsUyOe5M6av-w")
        
        return true
    }



}

