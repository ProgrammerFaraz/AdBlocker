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
        
        guard let jsonURL = documentFolder?.appendingPathComponent("blockerList.json") else {
            print("🔥🔥 jsonURL guard let failed!! 🔥🔥")
            return }
        guard let jsonURL2 = documentFolder?.appendingPathComponent("easylist_content_blocker.json") else {
            print("🔥🔥 jsonURL2 guard let failed!! 🔥🔥")
            return }
        
        let attachment = NSItemProvider(contentsOf: jsonURL)
//        let attachment2 = NSItemProvider(contentsOf: jsonURL2)
//        guard let attachment3 = attachment2 else {
//            print("🔥🔥 atachment2 guard let failed!! 🔥🔥")
//            return
//        }
        let item = NSExtensionItem()
        item.attachments = [attachment] as? [NSItemProvider]
//        item.attachments?.append(attachment3)
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
