//
//  String+Casing.swift
//  Nope
//
//  Created by Nathanial Woolls on 9/24/15.
//  Copyright © 2015 Nathanial Woolls. All rights reserved.
//

import Foundation

extension String {
//    func camelCaseToKebabCase() -> String {
//        return self.stringByReplacingOccurrencesOfString("([a-z])([A-Z])", withString: "$1-$2", options: .RegularExpressionSearch).lowercaseString
//    }
    
    func camelCaseToKebabCase() -> String? {
      let pattern = "([a-z0-9])([A-Z])"

      let regex = try? NSRegularExpression(pattern: pattern, options: [])
      let range = NSRange(location: 0, length: count)
      return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1-$2").lowercased()
    }
}
