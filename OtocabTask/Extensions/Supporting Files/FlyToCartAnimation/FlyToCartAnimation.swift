//
//  FlyToCartAnimation.swift
//  Dokanak
//
//  Created by MGoKu on 3/7/20.
//  Copyright © 2020 D-tag. All rights reserved.
//

import UIKit


func animation(currentView: UIView, tempView : UIView, counterLabel: UILabel, counterItem: Int, buttonCart: UIButton)  {
    
    currentView.addSubview(tempView)
    
    UIView.animate(withDuration: 1.0,
                   animations: {
                    tempView.animationZoom(scaleX: 1.5, y: 1.5)
    }, completion: { _ in
        tempView.layer.cornerRadius = tempView.bounds.height / 2
        tempView.layer.masksToBounds = true
        UIView.animate(withDuration: 0.5, animations: {
            
            tempView.animationZoom(scaleX: 0.2, y: 0.2)
            tempView.animationRoted(angle: CGFloat(Double.pi))
            
            tempView.frame.origin.x = buttonCart.frame.origin.x
            tempView.frame.origin.y = buttonCart.frame.origin.y
            
        }, completion: { _ in
            
            tempView.removeFromSuperview()
            
            UIView.animate(withDuration: 1.0, animations: {
                
                
//                counterLabel.text = "\(counterItem)"
                buttonCart.animationZoom(scaleX: 1.4, y: 1.4)
            }, completion: {_ in
                buttonCart.animationZoom(scaleX: 1.0, y: 1.0)
            })
            
        })
        
    })
}
extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}
