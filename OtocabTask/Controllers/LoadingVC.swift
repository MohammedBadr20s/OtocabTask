//
//  LoadingVC.swift
//  OtocabTask
//
//  Created by MGoKu on 5/5/20.
//  Copyright © 2020 MohammedBadr. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            guard let window = UIApplication.shared.keyWindow else { return }
            let main = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "LocationNav")
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
        }
    }

}
