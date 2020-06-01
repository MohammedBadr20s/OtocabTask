//
//  CustomCollectionView.swift
//  Dokanak
//
//  Created by D-TAG on 1/22/20.
//  Copyright © 2020 D-tag. All rights reserved.
//
import UIKit

@IBDesignable class CustomCollectionView: UICollectionView {
    
    //MARK:- Adding MasksToBounds
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    //MARK:- Adding shadow Color
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
        
    }
    //MARK:- Adding Shadow Opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    //MARK:- Adding shadow offset
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    //MARK:- Adding shadow radius
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    //MARK:- Adding Corner Radius to TextField
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    //MARK:- Border Width of TextField
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //MARK:- Adding borderColor to TextField
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
class CustomCollectionViewFlowLayout:UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = 2.0
        
        let horizontalSpacing:CGFloat = 5
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY
                || layoutAttribute.frame.origin.x == sectionInset.left {
                leftMargin = sectionInset.left
            }
            
            if layoutAttribute.frame.origin.x == sectionInset.left {
                leftMargin = sectionInset.left
            }
            else {
                layoutAttribute.frame.origin.x = leftMargin
            }
            
            leftMargin += layoutAttribute.frame.width + horizontalSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
