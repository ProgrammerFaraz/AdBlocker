//
//  Color+hex.swift
//  Security Manager
//
//  Created by Alexey Voronov on 27.08.2021.
//

import Foundation
import SwiftUI


extension Color {
    var uiColor: UIColor {
        if #available(iOS 14.0, *) {
            UIColor.init(self)
        } else {
            // Fallback on earlier versions
            return .clear
        }
        return .clear
    }
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    var rgba: RGBA? {
        var (r,g,b,a): RGBA = (0,0,0,0)
        if #available(iOS 14.0, *) {
            return uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
        } else {
            // Fallback on earlier versions
            return nil
        }
        return nil
    }
    var hexaRGB: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x",
            Int(rgba.red*255),
            Int(rgba.green*255),
            Int(rgba.blue*255))
    }
    var hexaRGBA: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x%02x",
            Int(rgba.red * 255),
            Int(rgba.green * 255),
            Int(rgba.blue * 255),
            Int(rgba.alpha * 255))
    }
}
