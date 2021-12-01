
import SwiftUI
import Introspect
import StoreKit
import Purchases
import AnyFormatKit
import LoadingButton

struct SelectionButton: View {
    let planDescText: String
    let selectedProduct: Purchases.Package
//    var product : SKProduct!
    var product : Purchases.Package
    let callback: (Purchases.Package)->()

    var body: some View {
        Button(action: {
//            self.isClicked.toggle()
            self.callback(self.product)
        }) {
            HStack {
//                Spacer()
//                    .frame(height: 25)
                Image(self.imageName(isClicked: (self.product == self.selectedProduct)))
                    .resizable()
                    .frame(CGSize(width: 20, height: 20))
                Spacer()
                    .frame(width: 20)
                VStack{
                    Text(product.localizedPriceString)
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                    Text(planDescText)
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                }
                Spacer()
            }
//            Spacer()
//                .frame(height: 15)

        }
    }

//    private func setDescription() -> String {
//        if product.description.lowercased().contains("monthlysubscription") {
//            return planDescText[0]
//        }else if product.description.lowercased().contains("yearlysubscription"){
//            return planDescText[1]
//        }
//        return ""
////        if product.localizedDescription.lowercased().contains("monthlysubscription"){
////            return planDescText[0]
////        }else{
////            return planDescText[1]
////        }
//    }
    
    private func imageName(isClicked: Bool) -> String {
        return isClicked ? "white_circle_filled" : "white_circle_unfilled"
    }
}

struct NewPurchaseView: View {
    
    @State private var isDisabled : Bool = false
    @State var products: [Purchases.Package]?
//    @State var selectedProduct: SKProduct = SKProduct()
    @State var selectedProduct: Purchases.Package = Purchases.Package()
    @State var showingAlert = false
    @State var planDescription : String = ""
    @State var alertMsg = "Something went wrong, try again later."
    @State var alertTitle = ""

    @Environment(\.presentationMode) var presentationMode
    @ViewBuilder var selectedPlanButton: some View {
        Image("")
    }
    @ViewBuilder var buttonText: some View {
        Text("Yes, Activate")
            .lineLimit(1)
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .frame(height: 65)
            .font(.system(size: 18, weight: .medium, design: .default))
//            .background(Color("AppRed"))
//            .cornerRadius(35)
            .minimumScaleFactor(0.05)
            .foregroundColor(Color.white)
            .padding([.leading, .trailing], 50)
    }
    @ViewBuilder var restoreText: some View {
        Text("Restore Purchase")
            .underline()
            .font(.system(size: 14, weight: .medium, design: .default))
            .foregroundColor(Color.gray)
            .minimumScaleFactor(0.05)
    }
    @State var presentingModal = false
    @State var showLoadingIndicator = false
    
    let style = LoadingButtonStyle(width: 220,
                                   height: 65,
                                   cornerRadius: 35,
                                   backgroundColor: Color("AppRed"),
                                   loadingColor: Color("AppRed").opacity(0.5),
                                   strokeWidth: 5,
                                   strokeColor: .gray)
//        .frame(minWidth: 0, maxWidth: .infinity)
        //            .frame(height: 65)
        //            .font(.system(size: 18, weight: .medium, design: .default))
        //            .background(Color("AppRed"))
        //            .cornerRadius(35)
        //            .foregroundColor(Color.white)
        //            .padding([.leading, .trailing], 50)
    @State var isLoading = false
    let dg = DragGesture()
    let pub = NotificationCenter.default
        .publisher(for: NSNotification.Name(Constants.showLoaderInPurchaseNotification))

    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        LoadingView(isShowing: $showLoadingIndicator) {
            ZStack {
                Image("purchaseViewBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack(){
                    Spacer()
                        .frame(height: 50)
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image("white_cross")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                    }
                    Text("Protect your Device")
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Spacer()
                        .frame(height: 25)
                    VStack(spacing: 10) {
//                        Spacer()
                        HStack{
                            Text("You will get")
                                .font(.system(size: 18, weight: .bold, design: .default))
//                            Spacer()
                        }
                        HStack{
                            Text("Advanced Adblocker")
//                            Spacer()
//                            ZStack{
//                                Image("white_circle_filled")
//                                    .resizable()
//                                    .frame(CGSize(width: 20, height: 20))
//                            }
                        }
                        HStack{
                            Text("Control Privacy & Stop Pops")
//                            Spacer()
//                            ZStack{
//                                Image("white_circle_filled")
//                                    .resizable()
//                                    .frame(CGSize(width: 20, height: 20))
//                            }
                        }
                        HStack{
                            Text("Accelerate Your Device")
//                            Spacer()
//                            ZStack{
//                                Image("white_circle_filled")
//                                    .resizable()
//                                    .frame(CGSize(width: 20, height: 20))
//                            }
                        }
                        HStack{
                            Text("Save Battery & Mobile Data")
//                            Spacer()
//                            ZStack{
//                                Image("white_circle_filled")
//                                    .resizable()
//                                    .frame(CGSize(width: 20, height: 20))
//                            }
                        }
//                        Spacer()
                    }
                    Spacer()
                        .frame(height: 30)
                    VStack{
                        if let products = products {
                            ForEach(products, id: \.self) { prod in
                                SelectionButton(planDescText: setDescription(prod: prod), selectedProduct: self.selectedProduct, product: prod) {
                                    selectedProd in
                                    self.selectedProduct = selectedProd
                                }
                            }
                        }
                    }
                    VStack(spacing: 20){
                        Spacer()
                        Text("Do you want to activate?")
                            .font(.system(size: 18, weight: .regular, design: .default))
                        LoadingButton(action: {
                            purchase(package: selectedProduct)
                        }, isLoading: $isLoading, style: style) {
                            buttonText
                        }
                        VStack{
                            Text("By continuing you accept our:")
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                                .minimumScaleFactor(0.05)
                            HStack{
                                Button(action: {
                                    self.presentingModal = true
                                }) {
                                    Text("Terms of Use")
                                        .underline()
                                        .lineLimit(1)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .foregroundColor(.blue)
                                        .minimumScaleFactor(0.05)
                                }
                                .sheet(isPresented: $presentingModal) { WebViewPage(request: URLRequest(url: URL(string: "https://gsmith.app/terms-of-use")!)) }
                                Text(" and ")
                                    .lineLimit(1)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .minimumScaleFactor(0.05)
                                    .foregroundColor(.gray)
                                Button(action: {
                                    self.presentingModal = true
                                }) {
                                    Text("Privacy Policy")
                                        .underline()
                                        .lineLimit(1)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .foregroundColor(.blue)
                                        .minimumScaleFactor(0.05)
                                }
                                .sheet(isPresented: $presentingModal) { WebViewPage(request: URLRequest(url: URL(string: "https://gsmith.app/privacy-policy")!)) }
                            }
                        }
                        .padding([.leading, .trailing], 50)
                        
                        Button(action: {
                            restorePurchases()
                        }) {
                            restoreText
                        }
                    }
                    Spacer()
                        .frame(height: 55)
                }
                .onReceive(pub) { output in
                    print("🔥 show loader: \(output.userInfo?["value"] as! Bool)🔥")
                    self.showLoadingIndicator = output.userInfo?["value"] as! Bool
                }
                .padding([.leading, .trailing], 25)
                .introspectViewController {
                    $0.isModalInPresentation = true
                }
                .onAppear() {
                    if let products = self.products {
                        if let product = products.first {
                            self.selectedProduct = product
                        }
                    }
//                    checkIfPurchased() // Was causing purchase view to open and close in 1-2 seconds automatically
                }
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("Ok")) {
                        print("Alert shown")
                    })
                })
                
            }
        }
    }
    
    func setDescription(prod: Purchases.Package) -> String {
        return prod.identifier.contains("rc_monthly") ? Constants.monthlyPriceDescription : Constants.yearlyPriceDescription
    }
    
    //MARK: - Actions
    
    func restorePurchases() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": true])
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            guard let purchaserInfo = purchaserInfo, error == nil else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                self.showingAlert = true
                self.alertMsg = error?.localizedDescription ?? ""
                return
            }
            if purchaserInfo.entitlements["Premium"]?.isActive ?? false {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                UserDefaults.standard.set(true, forKey: "isBuyed")
                self.dismiss()
            } else {
                if let expirationDate = purchaserInfo.entitlements["Premium"]?.expirationDate {
                    if expirationDate < Date() {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                        self.showingAlert = true
                        self.alertTitle = "Purchase Expired"
                        self.alertMsg = "Purchase Expired on \(expirationDate)"
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                        UserDefaults.standard.set(true, forKey: "isBuyed")
                        self.dismiss()
                    }
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                    self.showingAlert = true
                    self.alertTitle = "Error!"
                    self.alertMsg = "Unable to restore purchase"
                }
            }
            
        }
//        IAPManager.shared.restorePurchases(success: {
//            self.isDisabled = false
//            ProductsStore.shared.handleUpdateStore()
//            UserDefaults.standard.set(true, forKey: "isBuyed")
//            self.dismiss()
//
//        }) { (error) in
//            self.isDisabled = false
//            ProductsStore.shared.handleUpdateStore()
//
//        }
    }
    
    func termsTapped(){
        
    }
    
    func privacyTapped(){
        
    }
    
    func purchase(package: Purchases.Package) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": true])
        self.isLoading = true
        Purchases.shared.purchasePackage(package) { (transaction, info, error, userCancelled) in
            guard let transaction = transaction,
                  let info = info,
                  error == nil, !userCancelled
            else {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                self.isLoading = false
                self.showingAlert = true
                self.alertMsg = error?.localizedDescription ?? ""
                return
            }
            if transaction.transactionState == .purchased || transaction.transactionState == .restored {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInPurchaseNotification), object: nil, userInfo: ["value": false])
                self.isLoading = false
                UserDefaults.standard.set(true, forKey: "isBuyed")
                UserDefaults.standard.set(Date(), forKey: "TrialStarted")
                self.dismiss()
            }
            print(transaction.transactionState)
            print(info.entitlements)
        }
    }
    
//    func purchaseProduct(skproduct : SKProduct){
//        print("did tap purchase product: \(skproduct.productIdentifier)")
//        isDisabled = true
//        IAPManager.shared.purchaseProduct(product: skproduct, success: {
//            self.isDisabled = false
//            ProductsStore.shared.handleUpdateStore()
//            UserDefaults.standard.set(true, forKey: "isBuyed")
//            self.dismiss()
//        }) { (error) in
//            self.isDisabled = false
//            ProductsStore.shared.handleUpdateStore()
//            if error?.localizedDescription == nil {
//                UserDefaults.standard.set(true, forKey: "isBuyed")
//                self.dismiss()
//            }
//        }
//    }
    
    //MARK: - UI Setup
    
//    func fetchPackages(completion: @escaping ([Purchases.Package]) -> Void) {
//        Purchases.shared.offerings { (offerings, error) in
//            guard let offerings = offerings, error == nil else {
//                return
//            }
//            guard let packages = offerings.all.first?.value.availablePackages else { return }
//                 completion(packages)
//        }
//    }
    
    func checkIfPurchased() {
        Purchases.shared.purchaserInfo { (info, error) in
            guard let info = info, error == nil else { return }
            if info.entitlements["Premium"]?.isActive == true {
                print("TRUE")
                self.dismiss()
            }else {
                print("FALSE")
            }
        }
    }
//    func updatePurchasesView() -> SelectionButton {
//        var purchaseView : SelectionButton
//        Purchases.shared.offerings { (offerings, error) in
//            if let packages = offerings?.current?.availablePackages {
//                // Display packages for sale
//                ForEach(0..<packages.count-1) { index in
//                    purchaseView = SelectionButton(planDescText: planDescription, selectedProduct: self.selectedProduct, product: packages[index]) {
//                        selectedProd in
//                        self.selectedProduct = selectedProd
//                    }
//                }
//            }
//            return purchaseView
//        }
//    }
}

//struct NewPurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPurchaseView()
//    }
//}
