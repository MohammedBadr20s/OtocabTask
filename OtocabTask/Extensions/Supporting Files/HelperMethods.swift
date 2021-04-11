//
//  HelperMethods.swift
//  CharityProject
//
//  Created by D-TAG on 5/15/19.
//  Copyright © 2019 D-tag. All rights reserved.
//

import Foundation
import SwiftMessages


//MARK:- Display normal Alert
public func displayMessage(title: String, message: String, status: Theme, forController controller: UIViewController) {
    let success = MessageView.viewFromNib(layout: .cardView)
    success.configureTheme(status, iconStyle: .default )
    success.configureDropShadow()
    success.configureContent(title: title, body: message)
    success.button?.isHidden = true
    var successConfig = SwiftMessages.defaultConfig
    successConfig.duration = .seconds(seconds: 1)
    successConfig.presentationStyle = .top
    successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
    SwiftMessages.show(config: successConfig, view: success)
}


//MARK: - Localization and languages
public func localizedStringFor(key:String)->String {
    return NSLocalizedString(key, comment: "")
}
struct SocialNetworkUrl {
    let scheme: String
    let page: String
    
    func openPage() {
        let schemeUrl = NSURL(string: scheme)!
        if UIApplication.shared.canOpenURL(schemeUrl as URL) {
            UIApplication.shared.open(schemeUrl as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(NSURL(string: page)! as URL)
        }
    }
}

enum SocialNetwork {
    case WhatsApp, Twitter, Instagram, SnapChat
    func url() -> SocialNetworkUrl {
        switch self {
        case .Twitter: return SocialNetworkUrl(scheme: "twitter:///UserName", page: "https://twitter.com/UserName")
        case .SnapChat: return SocialNetworkUrl(scheme: "snapchat://add/UserName", page: "https://www.snapchat.com/add/UserName")
        case .WhatsApp: return SocialNetworkUrl(scheme: "https://wa.me/MobileNumber", page: "https://wa.me/MobileNumber")
        case .Instagram: return SocialNetworkUrl(scheme: "instagram://UserName", page:"https://www.instagram.com/UserName")
        }
    }
    func openPage() {
        self.url().openPage()
    }
}
