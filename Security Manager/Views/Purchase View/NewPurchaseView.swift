//
//  NewPurchaseView.swift
//  Security Manager
//
//  Created by Faraz on 10/21/21.
//

import SwiftUI

struct NewPurchaseView: View {
    var body: some View {
        ZStack {
            Image("purchaseViewBG")
                .resizable()
                .aspectRatio(contentMode: .fit)

        }
    }
}

struct NewPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NewPurchaseView()
    }
}
