
import Foundation
import Purchases

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func addProducts(products: [Purchases.Package]) {
        UserDefaults.standard.set(products, forKey: "purchasesProduct")
    }
    
    func getProducts() -> [Purchases.Package]? {
        guard let product = UserDefaults.standard.object(forKey: "purchasesProduct") as? [Purchases.Package]
        else { return nil }
        return product
    }
}
