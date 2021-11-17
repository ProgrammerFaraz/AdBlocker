//
//  BlockerEntry.swift
//  Nope
//
//  Created by Nathanial Woolls on 9/24/15.
//  Copyright © 2015 Nathanial Woolls. All rights reserved.
//

import Foundation

public class ELBlockerEntry {
    class Action {
        enum Typee : String {
            case Block
            case BlockCookies
            case CssDisplayNone
        }
        
        var type: String?
        var selector: String?
    }
    
    class Trigger {
        var urlFilter: String?
        var urlFilterIsCaseSensitive: Bool?
        var resourceType: [String]?
        var loadType: [String]?
        var ifDomain: [String]?
        var ifTopUrl: [String]?
        var unlessDomain: [String]?
        var unlessTopUrl: [String]?
    }
    
    var action: Action = Action()
    var trigger: Trigger = Trigger()
}
