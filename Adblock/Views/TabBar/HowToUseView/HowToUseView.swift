
import SwiftUI
import Purchases
import Drops

struct HowToUseView: View {
    
    @State private var currentPage = 0
    @State var showSheet = false
    
    @State var products: [Purchases.Package] = []

    @ViewBuilder var buttonText: some View {
        if currentPage == 3 {
            Text("Done")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 65)
                .font(.title)
                .background(Color("AppRed"))
                .cornerRadius(35)
                .foregroundColor(Color.white)
                .padding([.leading, .trailing], 50)
        }else {
            Text("Next")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 65)
                .font(.title)
                .background(Color.gray)
                .cornerRadius(35)
                .foregroundColor(Color.white)
                .padding([.leading, .trailing], 50)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 100)
            PagerView(pageCount: 4, currentIndex: $currentPage) {
                Image("howtouse-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
                Image("howtouse-2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
                Image("howtouse-3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
                Image("howtouse-4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
            }
            VStack(alignment: .leading) {
                Text("Step \(currentPage + 1)")
                    .padding(.leading, 25)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
                containedIndex()
                    .padding(.leading, 25)
                Spacer()
                    .frame(height: 25)
            }

            HStack(){
                Spacer()
                Button(action: {
                    nextTapped()
                }) {
                    buttonText
                }
                Spacer()
            }
            PageControl(selectedPage: $currentPage, pages: 4, circleDiameter: 50, circleMargin: 10)
                .padding(.trailing)
            Spacer()
                .frame(height: 50)
        }
        .onAppear() {
//            fetchPackages() {
//                packages in
//                print(packages)
//                self.products = packages
//                //                self.selectedProduct = self.products[0]
//
//            }
        }
        .sheet(isPresented: $showSheet) {
            NewPurchaseView(products: PurchaseProduct.shared.products)
        }
    }
    
//    func fetchPackages(completion: @escaping ([Purchases.Package]?, String?) -> Void) {
//        Purchases.shared.offerings { (offerings, error) in
//            guard let offerings = offerings, error == nil else {
//                completion(nil, error?.localizedDescription)
//                return
//            }
//            guard let packages = offerings.all.first?.value.availablePackages else { return }
//            completion(packages, nil)
//        }
//    }
    
    func containedIndex() -> Text {
        switch currentPage {
        case 0:
            return Text("Go to Setting App")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 1:
            return Text("Go to Safari")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 2:
            return Text("Go to the Content")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 3:
            return Text("Find Adblocker and Enable")
                .font(.system(size: 20, weight: .bold, design: .default))
        default: break
        }
        return Text("")
    }
    
    func nextTapped() {
        if currentPage == 3 {
            let isSubscribedUser = UserDefaults.standard.bool(forKey: "isBuyed")
            if isSubscribedUser {
                currentPage = 0
            }else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": true])
                if let products = PurchaseProduct.shared.products {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
                    PurchaseProduct.shared.products = products
                    ActiveSheet.shared.type = "purchase"
                    self.showSheet = true
                } else {
                    PurchaseManager.shared.fetchPackages() {
                        (packages, error) in
                        if error != nil {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
                            Drops.hideCurrent()
                            Drops.show(Drop(title: "Error Fetching Purchase", duration: 2.0))
                            //                        self.isActive = false
                        } else {
                            print(packages)
                            guard let packages = packages else { return }
                            PurchaseProduct.shared.products = packages
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
                            if PurchaseProduct.shared.products != nil {
                                ActiveSheet.shared.type = "purchase"
                                self.showSheet = true
                            } else {
                                Drops.hideCurrent()
                                Drops.show(Drop(title: "Error Loading Purchase", duration: 2.0))
                            }
                            //                        self.isActive = false
                        }
                    }
                }
//                self.showSheet = true
            }
//            currentPage = 0
        }else {
            currentPage += 1
        }
    }
}


struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
