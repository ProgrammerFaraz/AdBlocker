//
//  PurchaseButton.swift
//  https://apphud.com
//
//  Created by Apphud on 21/06/2019.
//  Copyright © 2019 apphud. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

struct PurchaseButton : View {
    
    var block : SuccessBlock!
    var product : SKProduct!
    
    var body: some View {
        
        Button(action: { 
            self.block()
        }) {
            Text(product.localizedPrice())
                .padding()
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
        .frame(width: 130, height: 80)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.18), lineWidth: 2)
        )
        .background(Color.white.opacity(0.04))
        .cornerRadius(20.0)
        .font(.custom(FontNames.exoMedium, size: 18))
    }
}
