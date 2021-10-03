//
//  ContentBlockerRequestHandler.swift
//  Super Agent Block
//
//  Created by Алексей Воронов on 30.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.App.appGroupId)
        
        guard let jsonURL = documentFolder?.appendingPathComponent("blockerList.json") else { return }
        
        let attachment = NSItemProvider(contentsOf: jsonURL)
        
        let item = NSExtensionItem()
        item.attachments = [attachment] as? [NSItemProvider]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
