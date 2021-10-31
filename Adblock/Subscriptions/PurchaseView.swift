//
//  ContentView.swift
//  https://apphud.com
//
//  Created by Apphud on 21/06/2019.
//  Copyright © 2019 apphud. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit
import Combine

struct PurchaseView : View {
    
    @State private var isDisabled : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var products: [SKProduct] = []
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Get Premium Membership")
                        .font(.custom(FontNames.exoMedium, size: 24))
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark").font(.system(size: 22))
                    }.foregroundColor(Colors.blueColor)
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                VStack {
                    Spacer()
                    self.purchaseButtons()
                    self.aboutText()
                    self.helperButtons().padding(.horizontal, 30)
                    self.termsText()
                        .frame(width: UIScreen.main.bounds.size.width)
                        .opacity(0.5)
                    self.dismissButton()
                    
                }
            }
            .disabled(self.isDisabled)
            .onAppear() {
                ProductsStore.shared.initializeProducts({ products in
                    self.products = products
                    print(products)
                })
        }
        }
    }
    
    // MARK: - View creations
    
    func purchaseButtons() -> some View {
        // remake to ScrollView if has more than 2 products because they won't fit on screen.
        HStack {
            ForEach(products, id: \.self) { prod in
                PurchaseButton(block: { 
                    self.purchaseProduct(skproduct: prod)
                }, product: prod).disabled(IAPManager.shared.isActive(product: prod))
            }
        }
    }
    
    func helperButtons() -> some View{
        HStack {
            Button(action: { 
                self.termsTapped()
            }) {
                Text("Terms of use")
            }
            Spacer()
            Button(action: { 
                self.privacyTapped()
            }) {
                Text("Privacy policy")
            }
        }
        .font(.custom(FontNames.exo, size: 14))
        .padding()
    }
    
    func aboutText() -> some View {
        Text("""
                • Safari AD block
                • Safari website blocker
                • Remove ADS
                """).font(.custom(FontNames.exo, size: 18)).lineLimit(nil).multilineTextAlignment(.center)
    }
    
    func termsText() -> some View{
        // Set height to 600 because SwiftUI has bug that multiline text is getting cut even if linelimit is nil.
        VStack {
            Text(terms_text).font(.custom(FontNames.exo, size: 14)).lineLimit(nil).padding().multilineTextAlignment(.center)
            //Spacer()
        }
    }
    
    func dismissButton() -> some View {
        Button(action: {
            self.restorePurchases()
        }) {
            Text("Restore purchases")
        }
        .padding()
        .font(.custom(FontNames.exo, size: 14))
    }
    
    //MARK: - Actions
    
    func restorePurchases(){
        
        IAPManager.shared.restorePurchases(success: { 
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
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

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
            .preferredColorScheme(.dark)
    }
}
