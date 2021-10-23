//
//  NewPurchaseView.swift
//  Security Manager
//
//  Created by Faraz on 10/21/21.
//

import SwiftUI
import Introspect

struct SelectionButton: View {
//    @Binding var isClicked: Bool
    let priceText: String
    let planDescText: String
    let selectedPrice: String
    let callback: (String)->()
    var body: some View {
        Button(action: {
//            self.isClicked.toggle()
            self.callback(self.priceText)
        }) {
            HStack {
//                Spacer()
//                    .frame(height: 25)
                Image(self.imageName(isClicked: (self.priceText == self.selectedPrice)))
                    .resizable()
                    .frame(CGSize(width: 20, height: 20))
                Spacer()
                    .frame(width: 20)
                VStack{
                    Text(self.priceText)
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
            Spacer()
                .frame(height: 15)

        }
    }
    
    private func imageName(isClicked: Bool) -> String {
        return isClicked ? "white_circle_filled" : "white_circle_unfilled"
    }
}

struct NewPurchaseView: View {
    
//    @State var selectedPlan: PaymentPlan = .Monthly
    @State var selectedPlan: String = ""
    let planItems : [String]
    let planDescription : [String] = [Constants.monthlyPriceDescription, Constants.yearlyPriceDescription]
    @Environment(\.presentationMode) var presentationMode
//    @State private var isSelected: Bool = false
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

//    @State private var viewModel = NewPurchaseViewModel()

    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
//        let paymentPlans = viewModel.setupData()
        ZStack {
            Image("purchaseViewBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack(){
                Spacer()
                    .frame(height: 50)
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
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
                    ForEach(0..<planItems.count){ index in
                        SelectionButton(priceText: planItems[index], planDescText: planDescription[index], selectedPrice: self.selectedPlan) { (str) in
                            print("🔥🔥 \(str)")
                            self.selectedPlan = str
                        }
                    }
                }
                VStack(spacing: 20){
                    Spacer()
                    Text("Do you want to activate?")
                        .font(.system(size: 18, weight: .regular, design: .default))
                    Button(action: {
                        self.dismiss()
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
        }
    }
}

//struct NewPurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPurchaseView()
//    }
//}
