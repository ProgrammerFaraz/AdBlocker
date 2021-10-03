//
//  Models.swift
//  Super Agent
//
//  Created by Алексей Воронов on 30.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import Foundation
import SwiftUI

class FilterSource {
    init(name: String, url: String, description: String, free: Bool, imageName: String, color: Color) {
        self.color = color
        self.imageName = imageName
        self.name = name
        self.url = url
        self.description = description
        self.free = free
    }
    
    let color: Color
    let imageName: String
    let name: String
    let url: String
    let description: String
    let free: Bool
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
            return UserDefaults.standard.bool(forKey: "\(self.name)-activate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(self.name)-activate")
        }
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
            documentDirectory.appendPathComponent("\(self.name).txt")
            return documentDirectory
        }
    }
    
    var listContent: String? {
        get {
            let content = try? String(contentsOf: fileURL)
            return content
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
        for i in 0...30 {
            if lines[i].contains("! Version: ") {
                self.version = lines[i].replacingOccurrences(of: "! Version: ", with: "")
            }
        }
    }
}
