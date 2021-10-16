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
    private init() {
        self.updateExtensionState()
    }
    
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
    
    func isFiltersDownloaded() -> Bool {
        for filter in Constants.filtersSources {
            if filter.listContent == nil {
                return false
            }
        }
        return true
    }
    
    func activateFilters(completion: @escaping (Error?) -> ()) {
        DispatchQueue.global().async {
            var filtersContents = ""
            for filterSource in Constants.filtersSources {
                if filterSource.activate {
                    filtersContents += filterSource.listContent ?? "" + "\n"
                }
            }
            
            var blockerEntries = ELListParser.parse(inputContent: filtersContents, maxEntries: 50000 - self.blockDomains.count, trustedDomains: self.trustDomains)
            
            for blockDomain in self.blockDomains {
                let entry = ELBlockerEntry()
                entry.trigger.urlFilter = ELFilterParser.parse(filter: blockDomain)
                entry.action.type = ELBlockerEntry.Action.Typee.Block.rawValue
                blockerEntries.append(entry)
            }
            
            if blockerEntries.count == 0 {
                self.deactivateFilters(completion: completion)
                return
            }
            
            guard let blockerJson = try? blockerEntries.serialize() else { return }
            
            print("my print")
            print(self.blockDomains)
            print(blockerEntries)
            print(blockerJson)
            
            let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Config.App.appGroupId)
            guard let jsonURL = documentFolder?.appendingPathComponent("blockerList.json") else { return }

            do {
                try blockerJson.data(using: .utf8)?.write(to: jsonURL)
            } catch {
                print(error.localizedDescription)
            }
            
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: Config.App.extensionBundleId) { error in
                print(error?.localizedDescription)
                print("activated")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func deactivateFilters(completion: @escaping (Error?) -> ()) {
        let filtersContents = ""
        var blockerEntries = ELListParser.parse(inputContent: filtersContents, maxEntries: 50000 - self.blockDomains.count, trustedDomains: [])
        
        
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
        
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: Config.App.extensionBundleId) { error in
            print(error?.localizedDescription)
            print("deactivated")
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func updateExtensionState() {
        let id = Config.App.extensionBundleId
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id, completionHandler: { state, error in
            DispatchQueue.main.async {
                if state?.isEnabled ?? true {
                    self.isExtensionActive = true
                } else {
                    self.isExtensionActive = false
                }
            }
        })
    }
    
    func getActivationState(completion: @escaping (Bool) -> ()) {
        let id = Config.App.extensionBundleId
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id, completionHandler: { state, error in
            DispatchQueue.main.async {
                if state?.isEnabled ?? false {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        })
    }
}
