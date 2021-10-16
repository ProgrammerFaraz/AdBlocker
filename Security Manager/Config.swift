//
//  Config.swift
//  Super Agent
//
//  Created by Алексей Воронов on 31.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import Foundation

var strings: [String] = []

struct Config {
    struct App {
        static let appBundleId = "gsmith.adblock-safari-popup-blocker5"
        static let extensionBundleId = "gsmith.adblock-safari-popup-blocker5.Security-Manager-Blocker"
        static let appGroupId = "group.securityBlock2"
        static let subscribeProductId = "sub7"
    }
    
    struct Ads {
        static let banner = "ca-app-pub-2383808832154477/1252433650"
        static let firstOpen = "ca-app-pub-2383808832154477/2068011240"
    }
    
    static let sub7DaysId = App.subscribeProductId
    static let sub30DaysId = App.subscribeProductId
}
