//
//  ELLineParser.swift
//  Nope
//
//  Created by Nathanial Woolls on 9/29/15.
//  Copyright © 2015 Nathanial Woolls. All rights reserved.
//

import Foundation

// https://adblockplus.org/filters
// https://adblockplus.org/filter-cheatsheet

class ELLineParser {
    
    static func parse(line: String) throws -> ELBlockerEntry {
        
        var error = "Unknown error"
        
        if let char = line.first {
            switch char {
            case "[", "!", "@" :
                error = "Unsupported prefix: \(char)"
                break
            default:
                
                var domainFilter: String = ""
                var cssSelector: String = ""
                var filterOptions: String = ""
                
                if line.contains("##") {
                    let cssParts = line.components(separatedBy: "##")
                    domainFilter = cssParts[0]
                    cssSelector = cssParts[1]
                } else if line.contains("$") {
                    
                    let line = line
                        .replacingOccurrences(of: "\\|~.*", with: "", options: .regularExpression)
                    
                    var optionParts = line.components(separatedBy: "$")
                    
                    //this may be more than 2 parts, e.g. 3, and the first 2 are the domain, concat
                    filterOptions = optionParts.last!
                    optionParts.removeLast()
                    domainFilter = optionParts.joined(separator: "");
                    
                } else {
                    domainFilter = line
                }
                
                if !domainFilter.canBeConverted(to: String.Encoding.ascii) {
                    // limitation of RegEx in WebKit Content Blocker
                    error = "Filter contains non-ASCII"
                    break
                }                
            
                if domainFilter.contains("{") {
                    // limitation of RegEx in WebKit Content Blocker
                    error = "Filter contains {"
                    break
                }
                
                if domainFilter.contains("#@#") {
                    error = "Filter contains #@#"
                    break
                }
                
                if domainFilter.contains("\\w") {
                    error = "Filter contains \\w"
                    break
                }
                
                if domainFilter.contains("\\d") {
                    error = "Filter contains \\d"
                    break
                }
                
                if domainFilter.contains("\\//") {
                    error = "Filter contains \\//"
                    break
                }

                let filterOptionParts: [String]
                if !filterOptions.isEmpty {
                    filterOptionParts = filterOptions.components(separatedBy: ",")
                    
                } else {
                    filterOptionParts = []
                }

                let entry = ELBlockerEntry()
                entry.trigger.urlFilter = ELFilterParser.parse(filter: domainFilter)
                
                if cssSelector.isEmpty {
                    entry.action.type = ELBlockerEntry.Action.Typee.Block.rawValue
                } else {
                    entry.action.type = ELBlockerEntry.Action.Typee.CssDisplayNone.rawValue
                    entry.action.selector = cssSelector
                }
                
                try ELOptionParser.parse(options: filterOptionParts, destination: entry)
                
                return entry
            }
            
        }
                
        throw ELParserError.InvalidInput(error, line)
    }
}
