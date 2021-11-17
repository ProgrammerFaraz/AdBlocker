//
//  JsonExtractor.swift
//  Ads Protector
//
//  Created by JJ on 15/10/2564 BE.
//  Copyright © 2564 jjcorp. All rights reserved.
//

import Foundation

class JsonExtractor {
    
    public static let trigger = "trigger"
    public static let triggerUrlFilter = "url-filter"
    public static let triggerUrlFilterIsCaseSensitive = "url-filter-is-case-sensitive"
    public static let triggerResourceType = "resource-type"
    public static let triggerUnlessTopUrl = "unless-top-url"
    public static let triggerLoadType = "load-type"
    public static let triggerIfDomain = "if-domain"
    public static let triggerUnlessDomain = "unless-domain"
    public static let triggerIfTopUrl = "if-top-url"
    
    public static let action = "action"
    public static let actionType = "type"
    public static let actionSelector = "selector"
    
    public static func extractContentBlocker(array: NSMutableArray) -> [ELBlockerEntry] {
        var blockEntries = [ELBlockerEntry]()
        for info in array {
            if let dict = info as? NSDictionary {
                let entry = ELBlockerEntry()
                if let triggerDict = dict[trigger] as? NSDictionary {
                    entry.trigger = extractTrigger(dict: triggerDict)
                }
                if let actionDict = dict[action] as? NSDictionary {
                    entry.action = extractAction(dict: actionDict)
                }
                blockEntries.append(entry)
            }
        }
        return blockEntries
    }
    
    private static func extractTrigger(dict: NSDictionary) -> ELBlockerEntry.Trigger {
        let trigger = ELBlockerEntry.Trigger()
        if let urlFilter = dict[triggerUrlFilter] as? String {
            trigger.urlFilter = urlFilter
        }
        if let urlFilterIsCaseSensitive = dict[triggerUrlFilterIsCaseSensitive] as? Bool {
            trigger.urlFilterIsCaseSensitive =  urlFilterIsCaseSensitive
        }
        if let unlessTopUrlArray = dict[triggerUnlessTopUrl] as? [String] {
            trigger.unlessTopUrl = unlessTopUrlArray
        }
        if let resourceTypes = dict[triggerResourceType] as? [String] {
            trigger.resourceType = resourceTypes
        }
        if let loadTypes = dict[triggerLoadType] as? [String] {
            trigger.loadType = loadTypes
        }
        if let ifDomains = dict[triggerIfDomain] as? [String] {
            trigger.ifDomain = ifDomains
        }
        if let unlessDomains = dict[triggerUnlessDomain] as? [String] {
            trigger.unlessDomain = unlessDomains
        }
        if let ifTopUrl = dict[triggerIfTopUrl] as? [String] {
            trigger.ifTopUrl = ifTopUrl
        }
        return trigger
    }
    
    private static func extractAction(dict: NSDictionary) -> ELBlockerEntry.Action {
        let action = ELBlockerEntry.Action()
        if let type = dict[actionType] as? String {
            action.type = type
        }
        if let selector = dict[actionSelector] as? String {
            action.selector = selector
        }
        return action
    }
    
    public static func nsdataToJSON(_ data: Data) -> AnyObject {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch _ {
            // Unable to serialize json
        }
        return 0 as AnyObject
    }
}
