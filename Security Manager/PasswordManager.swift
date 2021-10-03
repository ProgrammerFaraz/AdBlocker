//
//  PasswordManager.swift
//  Security Manager
//
//  Created by Alexey Voronov on 16.08.2021.
//

import Foundation
import KeychainSwift


class PasswordManager {
    let keychain = KeychainSwift()
    
    let separator = ":separator:"
    
    func getKeys() -> [String] {
        return self.keychain.allKeys
    }
    
    func updatePassword(key: String, newPassword: String) {
        if keychain.set(newPassword, forKey: key, withAccess: .accessibleWhenUnlocked) {
            print("Successfully updated password")
        } else {
            print("Error updating password")
        }
    }
    
    func updateUsername(key: String, password: String, newUsername: String, title: String) -> String {
        
        let newKey = title + self.separator + newUsername
        
        if keychain.delete(key) {
            if keychain.set(password, forKey: newKey, withAccess: .accessibleWhenUnlocked) {
                print("Username successfully updated")
            } else {
                print("Error updating username")
            }
        } else {
            print("failed to delete key")
        }
        return newKey
    }
    
    func deletePassword(key: String) {
        if keychain.delete(key) {
            print("Successfully deleted")
        } else {
            print("Error deleting password")
        }
    }
}

class PasswordItemModel {
    var title, username, password: String
    
    init(key: String, passManager: PasswordManager) {
        let keyItems = key.components(separatedBy: passManager.separator)
        self.passManager = passManager
        if keyItems.count > 1 {
            self.title = keyItems[0]
            self.username = keyItems[1]
        } else {
            self.title = ""
            self.username = ""
        }
        self.password = ""
    }
    
    init(title: String, username: String, password: String, passManager: PasswordManager) {
        self.passManager = passManager
        self.title = title
        self.username = username
        self.password = password
    }
    
    let passManager: PasswordManager
    
    lazy var key: String = {
        return title + passManager.separator + username
    }()
    
    func loadFromKeychain() {
        print(key)
        password = passManager.keychain.get(self.key) ?? password
    }
    
    func saveToKeychain() {
        if self.passManager.keychain.set(password, forKey: key) {
            print("Successfully saved to Keychain")
            print(key)
        } else {
            print("Error saving to Keychain")
        }
    }
}
