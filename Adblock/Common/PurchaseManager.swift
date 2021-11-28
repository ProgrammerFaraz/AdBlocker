//
//  PurchaseManager.swift
//  Adblock
//
//  Created by Faraz on 11/28/21.
//

import Foundation
import Purchases

class PurchaseManager {
    
    static let shared = PurchaseManager()
    
    private init() {}
    
    func fetchPackages(completion: @escaping ([Purchases.Package]?, String?) -> Void) {
        Purchases.shared.offerings { (offerings, error) in
            guard let offerings = offerings, error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            guard let packages = offerings.all.first?.value.availablePackages else { return }
            UserDefaultsManager.shared.addProducts(products: packages)
            completion(packages, nil)
        }
    }
}
