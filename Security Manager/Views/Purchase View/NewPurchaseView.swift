//
//  NewPurchaseView.swift
//  Security Manager
//
//  Created by Faraz on 10/21/21.
//

import SwiftUI
import Introspect
import StoreKit

struct SelectionButton: View {
//    @Binding var isClicked: Bool
//    let priceText: String
    let planDescText: [String]
    let selectedProduct: SKProduct
    var product : SKProduct!
    let callback: (SKProduct)->()

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
                    Text(product.localizedPrice())
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
        if product.localizedDescription.lowercased().contains("monthlysubscription"){
            return planDescText[0]
        }else{
            return planDescText[1]
        }
    }
    
    private func imageName(isClicked: Bool) -> String {
        return isClicked ? "white_circle_filled" : "white_circle_unfilled"
    }
}

struct NewPurchaseView: View {
    
    @State private var isDisabled : Bool = false
    @State var products: [SKProduct] = []
    //    @State var selectedPlan: PaymentPlan = .Monthly
    @State var selectedProduct: SKProduct = SKProduct()
//    let planItems : [String]
    let planDescription : [String] = [Constants.monthlyPriceDescription, Constants.yearlyPriceDescription]

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
                        Text("Accelerate Your Device")
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
                        self.purchaseProduct(skproduct: self.selectedProduct)
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
                ProductsStore.shared.initializeProducts({ products in
                    self.products = products
                    self.selectedProduct = self.products[0]
                    print(products)
                })
            }
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
}

//struct NewPurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPurchaseView()
//    }
//}
