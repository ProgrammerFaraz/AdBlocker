
import Foundation
import Purchases

//extension Purchases.Package: Codable {
//    public func encode(to encoder: Encoder) throws {
//        encode.encodeObject(to: )
//    }
//
//    public required init(from decoder: Decoder) throws {
//
//        self.product = decoder.unkeyedContainer().decode(SKProduct.self)
//
//    }
//}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
//    public static var currentPackages: [Purchases.Package]? {
//        get{
//            if let data = UserDefaults.standard.data(forKey: "currentPackages") {
//                let decoder = JSONDecoder()
//                do{
//                    let decoded = try decoder.decode([Purchases.Package].self, from: data)
//                    return decoded
//                }catch{
//                    return nil
//                }
//            }
//            return nil
//        }
//        set{
//            let encoder = JSONEncoder()
//            do {
//                let jsonData = try encoder.encode(newValue)
//                UserDefaults.standard.set(jsonData, forKey: "currentPackages")
//
//            }catch{
//                print("CurrentUser not save")
//            }
//        }
//    }
    
//    func addProducts(products: Any) {
//        do {
//            let data = try JSONSerialization.data(withJSONObject: products, options: .fragmentsAllowed)
//            UserDefaults.standard.set(data, forKey: "purchasesProduct")
//        } catch {
//            print("PurchasesProduct not save")
//        }
//    }
    
//    func getProducts() -> [Purchases.Package]? {
//        guard let product = UserDefaults.standard.data(forKey: "purchasesProduct") //as? [Purchases.Package]
//        else { return nil }
//        do {
//            guard let json = try JSONSerialization.jsonObject(with: product, options: .fragmentsAllowed) as? [Purchases.Package] else { return nil}
//            return json
//        } catch {
//            print("PurchasesProduct not fetched")
//            return nil
//        }
//    }
}

class PurchaseProduct {
    static var shared = PurchaseProduct()
    private init() {}
    init(products: [Purchases.Package]) {
        self.products = products
//        self.identifier = identifier
//        self.packageType = packageType
//        self.product = product
//        self.localizedPriceString = localizedPriceString
//        self.localizedIntroductoryPriceString = localizedIntroductoryPriceString
    }
    var products : [Purchases.Package]?
}

//struct Products {
//    var identifier: String?
//    var packageType: Purchases.PackageType?
//    var product: SKProduct?
//    var localizedPriceString: String?
//    var localizedIntroductoryPriceString: String?
//}
