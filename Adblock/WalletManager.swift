////
////  WalletManager.swift
////  Security Manager
////
////  Created by Alexey Voronov on 27.08.2021.
////
//
//import Foundation
//import SwiftUI
//
//
//class WalletManager {
//    let key = "wallet"
//    let separator = ":separator:"
//    
//    func saveCards(cards: [Card]) {
//        let values = cards.map({"\($0.number):separator:\($0.date):separator:\($0.cvv):separator:\($0.owner):separator:\($0.backgroundColor.hexaRGBA ?? "")"})
//        UserDefaults.standard.set(values, forKey: key)
//    }
//    
//    func loadCards() -> [Card] {
//        guard let values = UserDefaults.standard.array(forKey: key) as? [String] else { return [] }
//        
//        var cards: [Card] = []
//        
//        for value in values {
//            let comps = value.components(separatedBy: separator)
//            
//            guard comps.count == 5 else { return [] }
//            
//            let card = Card(backgroundColor: Color(hexadecimal: comps[4]), yOffset: 0)
//            card.number = comps[0]
//            card.date = comps[1]
//            card.cvv = comps[2]
//            card.owner = comps[3]
//            
//            cards.append(card)
//        }
//        
//        return cards
//    }
//}
