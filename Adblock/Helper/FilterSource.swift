//
//  Models.swift
//  Super Agent
//
//  Created by Алексей Воронов on 30.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import Foundation
import SwiftUI

class FilterSource: Identifiable {
    init(name: String,
         url: String,
         description: String,
         free: Bool,
         imageName: String,
         color: Color,
         whiteBlackList: Bool,
         defaultActivate: Bool,
         isRawJson: Bool) {
        self.name = name
        self.url = url
        self.description = description
        self.free = free
        self.isRawJson = isRawJson
        self.imageName = imageName
        self.color = color
        self.whiteBlackList = whiteBlackList
        if self.isKeyPresentInUserDefaults(key: activateKey) {
            self.activate = UserDefaults.standard.bool(forKey: activateKey)
        } else {
            self.activate = defaultActivate
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    let id = UUID()
    let name: String
    let url: String
    let description: String
    let free: Bool
    let color: Color
    let imageName: String

    let whiteBlackList: Bool
    let isRawJson: Bool
    var version: String {
        get {
            return UserDefaults.standard.string(forKey: "\(self.name)-version") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(self.name)-version")
        }
    }
    var activate: Bool {
        get {
            return UserDefaults.standard.bool(forKey: activateKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: activateKey)
        }
    }
    
    var activateKey: String {
        get { "\(self.name)-activate" }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'.'MM'.'dd' 'HH':'mm'"
        return dateFormatter
    }
    var updateDate: Date? {
        get {
            guard let dateString = UserDefaults.standard.string(forKey: "\(self.name)-updateDate") else {
                return nil
            }
            return self.dateFormatter.date(from: dateString)
        }
        set {
            if newValue != nil {
                let dateString = dateFormatter.string(from: newValue!)
                UserDefaults.standard.set(dateString, forKey: "\(self.name)-updateDate")
            }
        }
    }
    
    private var fileURL: URL {
        get {
            let fileManager = FileManager.default
            var documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileName = isRawJson ? "\(self.name).json" : "\(self.name).txt"
            documentDirectory.appendPathComponent(fileName)
            return documentDirectory
        }
    }
    
    var listContent: String? {
        get {
            let content = try? String(contentsOf: fileURL)
            return content
        }
    }
    
    var jsonArrayObject: NSMutableArray? {
        get {
            guard let easylistData = try? Data(contentsOf: fileURL) else { return nil }
            let easylistJSON = JsonExtractor.nsdataToJSON(easylistData) as? NSMutableArray
            return easylistJSON
        }
    }
    
    func updateList(completion: @escaping (Error?) -> ()) {
        DispatchQueue.global().sync {
            guard let urlWeb = URL(string: self.url) else { return }
            var content = ""
            do {
                content = try String(contentsOf: urlWeb)
            } catch {
                completion(error)
                return
            }
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: self.fileURL.absoluteString){
                do {
                    try fileManager.removeItem(atPath: self.fileURL.absoluteString)
                } catch let error {
                    print("updateList removeItem error occurred, here are the details:\n \(error)")
                }
            }
            do {
                try content.write(to: self.fileURL, atomically: false, encoding: .utf8)
                DispatchQueue.main.async {
                    self.parseInfo()
                    self.updateDate = Date()
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func parseInfo() {
        if self.listContent == nil { return }
        let lines = self.listContent!.split { $0.isNewline }
        let maxExpectedLine = lines.count > 30 ? 30 : lines.count-1
        for i in 0...(maxExpectedLine) {
            if lines[i].contains("! Version: ") {
                self.version = lines[i].replacingOccurrences(of: "! Version: ", with: "")
            }
        }
    }
}
