
import SwiftUI
import Introspect
import StoreKit
import Purchases

struct SelectionButton: View {
    let planDescText: [String]
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
                    Text(setDescription())
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

    private func setDescription() -> String {
        if product.description.lowercased().contains("monthlysubscription") {
            return planDescText[0]
        }else {
            return planDescText[1]
        }
//        if product.localizedDescription.lowercased().contains("monthlysubscription"){
//            return planDescText[0]
//        }else{
//            return planDescText[1]
//        }
    }
    
    private func imageName(isClicked: Bool) -> String {
        return isClicked ? "white_circle_filled" : "white_circle_unfilled"
    }
}

struct NewPurchaseView: View {
    
    @State private var isDisabled : Bool = false
    @State var products: [Purchases.Package] = []
//    @State var selectedProduct: SKProduct = SKProduct()
    @State var selectedProduct: Purchases.Package = Purchases.Package()
    @State var showingAlert = false
    let planDescription : [String] = [Constants.monthlyPriceDescription, Constants.yearlyPriceDescription]
    @State var alertMsg = "Something went wrong, try again later."
    @Environment(\.presentationMode) var presentationMode
    @ViewBuilder var selectedPlanButton: some View {
        Image("")
    }
    @ViewBuilder var buttonText: some View {
        Text("Yes, Activate")
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 65)
            .font(.system(size: 18, weight: .medium, design: .default))
            .background(Color("AppRed"))
            .cornerRadius(35)
            .foregroundColor(Color.white)
            .padding([.leading, .trailing], 50)
    }
    let dg = DragGesture()

    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
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
                        restorePurchases()
//                            dismiss()
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
                VStack {
                    HStack{
                        Text("You will get")
                            .font(.system(size: 18, weight: .bold, design: .default))
                        Spacer()
                    }
                    HStack{
                        Text("Advanced Adblocker")
                        Spacer()
                        ZStack{
                            Image("white_circle_filled")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                    }
                    HStack{
                        Text("Control Privacy & Stop Pops")
                        Spacer()
                        ZStack{
                            Image("white_circle_filled")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                    }
                    HStack{
                        Text("Accelerate Your Device")
                        Spacer()
                        ZStack{
                            Image("white_circle_filled")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                    }
                    HStack{
                        Text("Save Battery & Mobile Data")
                        Spacer()
                        ZStack{
                            Image("white_circle_filled")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                    }
                }
                Spacer()
                    .frame(height: 40)
                VStack{
//                    updatePurchasesView()
                    ForEach(products, id: \.self) { prod in
                        SelectionButton(planDescText: planDescription, selectedProduct: self.selectedProduct, product: prod) {
                            selectedProd in
                            self.selectedProduct = selectedProd
                        }
                    }
//                    ForEach(0..<planItems.count){ index in
//                        SelectionButton(priceText: planItems[index], planDescText: planDescription[index], selectedPrice: self.selectedPlan) { (str) in
//                            print("🔥🔥 \(str)")
//                            self.selectedPlan = str
//                        }
//                    }
                }
//                HStack{
//                    ForEach(products, id: \.self) { prod in
//                        PurchaseButton(block: {
//                            self.purchaseProduct(skproduct: prod)
//                        }, product: prod).disabled(IAPManager.shared.isActive(product: prod))
//                    }
//                }
                VStack(spacing: 20){
                    Spacer()
                    Text("Do you want to activate?")
                        .font(.system(size: 18, weight: .regular, design: .default))
                    Button(action: {
                        purchase(package: selectedProduct)
//                        self.purchaseProduct(skproduct: self.selectedProduct)
                    }) {
                        buttonText
                    }
                    Text("By continuing you accept our Terms of Use and Privacy Policy")
                        .minimumScaleFactor(0.05)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding([.leading, .trailing], 50)
                }
                
                Spacer()
                    .frame(height: 25)
            }
            .padding([.leading, .trailing], 25)
            .introspectViewController {
                $0.isModalInPresentation = true
            }
            .disabled(self.isDisabled)
            .onAppear() {
//                fetchPackages() {
//                    packages in
//                    print(packages)
                self.selectedProduct = self.products[0]
//                }
                checkIfPurchased()
//                ProductsStore.shared.initializeProducts({ products in
//                    self.products = products
//                    self.selectedProduct = self.products[0]
//                    print(products)
//                })
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("Ok")) {
                    print("Alert shown")
                })
            })
            
        }
    }
    
    //MARK: - Actions
    
    func restorePurchases(){
        
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            UserDefaults.standard.set(true, forKey: "isBuyed")
            self.dismiss()
            
        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            
        }
    }
    
    func termsTapped(){
        
    }
    
    func privacyTapped(){
        
    }
    
    func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { (transaction, info, error, userCancelled) in
            guard let transaction = transaction,
                  let info = info,
                  error == nil, !userCancelled
            else {
                self.showingAlert = true
                self.alertMsg = error?.localizedDescription ?? ""
                return
            }
            UserDefaults.standard.set(true, forKey: "isBuyed")
            self.dismiss()
            print(transaction.transactionState)
            print(info.entitlements)
        }
    }
    
    func purchaseProduct(skproduct : SKProduct){
        print("did tap purchase product: \(skproduct.productIdentifier)")
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            UserDefaults.standard.set(true, forKey: "isBuyed")
            self.dismiss()
        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            if error?.localizedDescription == nil {
                UserDefaults.standard.set(true, forKey: "isBuyed")
                self.dismiss()
            }
        }
    }
    
    //MARK: - UI Setup
    
    func fetchPackages(completion: @escaping ([Purchases.Package]) -> Void) {
        Purchases.shared.offerings { (offerings, error) in
            guard let offerings = offerings, error == nil else {
                return
            }
            guard let packages = offerings.all.first?.value.availablePackages else { return }
                 completion(packages)
        }
    }
    
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
