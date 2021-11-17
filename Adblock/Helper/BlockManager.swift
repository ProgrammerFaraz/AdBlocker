//
//  File.swift
//  Super Agent
//
//  Created by Алексей Воронов on 31.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import Foundation
import SafariServices


class BlockManager {
    static var shared = BlockManager()
    private init() {}
    
    var isExtensionActive = false
    var shouldReload = false
    
    var trustDomains: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "trustDomains") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "trustDomains")
        }
    }
    
    var blockDomains: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "blockDomains") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "blockDomains")
        }
    }
    
    var reportingDomains: [Int:String] {
        get {
            return UserDefaults.standard.object([Int: String].self, with: "reportingDomains") ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reportingDomains")
        }
    }
    
    func isFiltersDownloaded() -> Bool {
        let filters = Constants.filtersSources.filter { (filter) -> Bool in
            filter.url != ""
        }
        for filter in filters {
            if filter.listContent == nil {
                return false
            }
        }
        return true
    }
    
    func activateFilters(completion: @escaping (Error?) -> ()) {
        performActivateContentBlocker()
        reloadContentBlocker(type: "Activate", completion)
    }
    
    private func performActivateContentBlocker() {
        
//        var filtersContents = ""
//        for filterSource in Constants.filtersSources {
//            if filterSource.activate,
//               filterSource.isRawJson {
//                filtersContents += filterSource.listContent ?? "" + "\n"
//            }
//        }
//        let blockerJson = filtersContents
        
        var blockerEntries = [ELBlockerEntry]()
        
        let contentArrays = NSMutableArray()
        for filterSource in Constants.filtersSources {
            if filterSource.activate,
               filterSource.isRawJson,
               let array = filterSource.jsonArrayObject {
                contentArrays.addObjects(from: array as [AnyObject])
            }
        }

        let contentBlockers = JsonExtractor.extractContentBlocker(array: contentArrays)
        if contentBlockers.count > 0 {
            blockerEntries.append(contentsOf: contentBlockers)
        }
        
        var filtersContents = ""
        for filterSource in Constants.filtersSources {
            if filterSource.activate,
               !filterSource.isRawJson {
                filtersContents += filterSource.listContent ?? "" + "\n"
            }
        }
        let parsedBlockerEntries = ELListParser.parse(inputContent: filtersContents,
                                                      maxEntries: 50000 - blockerEntries.count - self.blockDomains.count,
                                                      trustedDomains: self.trustDomains)
        if parsedBlockerEntries.count > 0 {
            blockerEntries.append(contentsOf: parsedBlockerEntries)
        }
        
        for blockDomain in self.blockDomains {
            let entry = ELBlockerEntry()
            entry.trigger.urlFilter = ELFilterParser.parse(filter: blockDomain)
            entry.action.type = ELBlockerEntry.Action.Typee.Block.rawValue
            blockerEntries.append(entry)
        }

        guard let blockerJson = try? blockerEntries.serialize() else { return }
        
        let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.App.appGroupId)
        guard let jsonURL = documentFolder?.appendingPathComponent("blockerList.json") else { return }

        do {
            try blockerJson.data(using: .utf8)?.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deactivateFilters(completion: @escaping (Error?) -> ()) {
        performDeactivateContentBlocker()
        reloadContentBlocker(type: "Deactivate", completion)
    }
    
    private func performDeactivateContentBlocker() {
        var blockerEntries = [ELBlockerEntry]()
        
        let contentArrays = NSMutableArray()
        for filterSource in Constants.filtersSources {
            if filterSource.activate,
               filterSource.isRawJson,
               let array = filterSource.jsonArrayObject {
                contentArrays.addObjects(from: array as [AnyObject])
            }
        }

        let contentBlockers = JsonExtractor.extractContentBlocker(array: contentArrays)
        if contentBlockers.count > 0 {
            blockerEntries.append(contentsOf: contentBlockers)
        }
        var filtersContents = ""
        for filterSource in Constants.filtersSources {
            if filterSource.activate,
               !filterSource.isRawJson {
                filtersContents += filterSource.listContent ?? "" + "\n"
            }
        }
        let parsedBlockerEntries = ELListParser.parse(inputContent: filtersContents, maxEntries: 50000 - self.blockDomains.count, trustedDomains: [])
        if parsedBlockerEntries.count > 0 {
            blockerEntries.append(contentsOf: parsedBlockerEntries)
        }
        
        let entry = ELBlockerEntry()
        entry.trigger.urlFilter = ELFilterParser.parse(filter: "dummyDomain.com")
        entry.action.type = ELBlockerEntry.Action.Typee.Block.rawValue
        blockerEntries.append(entry)
        
        guard let blockerJson = try? blockerEntries.serialize() else { return }
        
        let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.App.appGroupId)
        guard let jsonURL = documentFolder?.appendingPathComponent("blockerList.json") else { return }

        do {
            try blockerJson.data(using: .utf8)?.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func reloadContentBlocker(type: String, _ completion: @escaping (Error?) -> ()) {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: Config.App.extensionBundleId) { error in
            print(error?.localizedDescription)
            print(type)
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func getActivationState(completion: @escaping (Bool) -> ()) {
           let id = Config.App.extensionBundleId
           SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id, completionHandler: { state, error in
               DispatchQueue.main.async {
                   print(error?.localizedDescription)
                   if state?.isEnabled ?? false {
                       completion(true)
                   } else {
                       completion(false)
                   }
               }
           })
       }
}
