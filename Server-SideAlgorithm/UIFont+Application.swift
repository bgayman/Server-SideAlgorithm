//
//  UIFont+Application.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

extension UIFont
{
    static let app_fontName = "Menlo-Regular"
    static let app_boldFontName = "Menlo-Bold"
    
    static func app_font(ofSize size: CGFloat) -> UIFont
    {
        return UIFont(name: UIFont.app_fontName, size: size)!
    }
    
    static func app_boldFont(ofSize size: CGFloat) -> UIFont
    {
        return UIFont(name: UIFont.app_boldFontName, size: size)!
    }
}
