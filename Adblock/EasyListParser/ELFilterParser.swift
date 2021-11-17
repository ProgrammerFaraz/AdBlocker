//
//  ELFilterParser.swift
//  Nope
//
//  Created by Nathanial Woolls on 9/29/15.
//  Copyright © 2015 Nathanial Woolls. All rights reserved.
//

import Foundation

// https://adblockplus.org/filters
// https://adblockplus.org/filter-cheatsheet

// transform an EasyList domain / URL filter into a real RegEx
class ELFilterParser {
    static func parse(filter: String) -> String {
        var result = filter
        if result.isEmpty {
            result = ".*"
        } else {
            
            // escape special regex characters
            result = result
                .replacingOccurrences(of: ".", with: "\\.")
                .replacingOccurrences(of: "?", with: "\\?")
                .replacingOccurrences(of: "+", with: "\\+")
            
            // * is to be assumed, but may already be present in the domain
            // or the domain may include pipes to override the liberal use of *
            if result.first != "*" && result.first != "|" {
                result = "*" + result
            }
            if result.last != "*" && result.last != "|" && result.last != "^" {
                result += "*"
            }
            
            // * matches any series of characters
            result = result.replacingOccurrences(of: "*", with: ".*")
            
            let separator = "[\\?\\/\\-_:]"
            
            // ^ marks a separator character like ? or / has to follow.
            // must do in 2 steps as ContentBlocker RegEx doesn't support (this|format)
            if result.last == "^" {
                result = String(result.dropLast())
                result += "(" + separator + ".*)?$"
            }
            
            result = result.replacingOccurrences(of: "^", with: separator)
            
            // || marks the begining of a domain
            if result.starts(with: "||") {
                result = String(result.dropFirst(2))
                result = "^(?:[^:/?#]+:)?(?://(?:[^/?#]*\\.)?)?" + result
            }
            
            // | marks the beginning of a domain
            if result.first == "|" {
                result = String(result.dropFirst())
                result = "^" + result
            }
            
            // | marks the end of a domain
            if result.last == "|" {
                result = String(result.dropLast())
                result += "$"
            }
            
            // escape remaining special regex characters incl. pipes
            result = result.replacingOccurrences(of: "|", with: "\\|")
            
            // unescape the over-escaped - EasyList has some occasional escaping
            result = result.replacingOccurrences(of: "\\\\", with: "\\")
        }
        return result
    }

}
