//
//  ELBlockerEntry+JSON.swift
//  EasyListParser
//
//  Created by Nathanial Woolls on 10/10/15.
//  Copyright © 2015 Nathanial Woolls. All rights reserved.
//

import Foundation

extension ELBlockerEntry {
    public func serialize(prettyPrinted: Bool = false) throws -> String?  {
        let json = try JSONSerialization.data(withJSONObject: self.toCBEntry(), options: (prettyPrinted ? .prettyPrinted : JSONSerialization.WritingOptions()))
        return NSString(data: json, encoding: String.Encoding.utf8.rawValue) as String?
    }
}

extension Array where Element: ELBlockerEntry {
    public func serialize(prettyPrinted: Bool = false) throws -> String?  {
        var subArray = [NSDictionary]()
        for item in self {
            subArray.append(item.toCBEntry())
        }
        
        let json = try JSONSerialization.data(withJSONObject: subArray, options: (prettyPrinted ? .prettyPrinted : JSONSerialization.WritingOptions()))
        return NSString(data: json, encoding: String.Encoding.utf8.rawValue) as String?
    }
}

extension ELBlockerEntry {
    public func toCBEntry() -> NSDictionary {
        let result = NSMutableDictionary()
        
        result.setValue(self.trigger.toCBEntry(), forKey: "trigger")
        
        result.setValue(self.action.toCBEntry(), forKey: "action")
        
        return result
    }
}

extension ELBlockerEntry.Trigger {
    func toCBEntry() -> NSDictionary {
        let result = NSMutableDictionary()
        
        if let triggerUrlFilter = self.urlFilter {
            result.setValue(triggerUrlFilter, forKey: JsonExtractor.triggerUrlFilter)
        }
        
        if let triggerUrlFilterIsCaseSensitive = self.urlFilterIsCaseSensitive {
            result.setValue(triggerUrlFilterIsCaseSensitive, forKey: JsonExtractor.triggerUrlFilterIsCaseSensitive)
        }
        
        if let triggerResourceType = self.resourceType {
            result.setValue(triggerResourceType, forKey: JsonExtractor.triggerResourceType)
        }
        
        if let triggerLoadType = self.loadType {
            result.setValue(triggerLoadType, forKey: JsonExtractor.triggerLoadType)
        }
        
        if let triggerIfDomain = self.ifDomain {
            result.setValue(triggerIfDomain, forKey: JsonExtractor.triggerIfDomain)
        }
        
        if let triggerUnlessDomain = self.unlessDomain {
            result.setValue(triggerUnlessDomain, forKey: JsonExtractor.triggerUnlessDomain)
        }
        
        if let triggerUnlessTopUrl = self.unlessTopUrl {
            result.setValue(triggerUnlessTopUrl, forKey: JsonExtractor.triggerUnlessTopUrl)
        }
        
        if let triggerIfTopUrl = self.ifTopUrl {
            result.setValue(triggerIfTopUrl, forKey: JsonExtractor.triggerIfTopUrl)
        }
        
        return result
    }
}

extension ELBlockerEntry.Action {
    func toCBEntry() -> NSDictionary {
        let result = NSMutableDictionary()
        
        if let actionType = self.type {
            result.setValue(actionType.camelCaseToKebabCase(), forKey: "type")
        }
        
        if let actionSelector = self.selector {
            result.setValue(actionSelector, forKey: "selector")
        }
        
        return result
    }
}
