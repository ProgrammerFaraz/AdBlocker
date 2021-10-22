//
//  NewPurchaseView.swift
//  Security Manager
//
//  Created by Faraz on 10/21/21.
//

import SwiftUI

enum PaymentPlan {
    case Monthly
    case Yearly
}

struct NewPurchaseView: View {
    
    @State var selectedPlan: PaymentPlan = .Monthly
//    @Binding var isSelected: Bool = false
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
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Image("purchaseViewBG")
                .resizable()
                .aspectRatio(contentMode: .fit)
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
                    HStack{
                        Spacer()
                            .frame(width: 25)
                        Button(action: { dismiss() }) {
                            Image("white_circle_filled")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                        Spacer()
                            .frame(width: 20)
                        VStack{
                            Text("29.99 / Month")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                            Text("Per Month, auto renewal")
                                .font(.system(size: 10, weight: .medium, design: .default))
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 15)
                    HStack{
                        Spacer()
                            .frame(width: 25)
                        Button(action: { dismiss() }) {
                            Image("white_circle_unfilled")
                                .resizable()
                                .frame(CGSize(width: 20, height: 20))
                        }
                        Spacer()
                            .frame(width: 20)
                        VStack{
                            Text("59.99 / Year")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                            Text("Per Year, auto renewal")
                                .font(.system(size: 10, weight: .medium, design: .default))
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                    }
                }
                VStack(spacing: 20){
                    Spacer()
                    Text("Do you want to activate?")
                        .font(.system(size: 18, weight: .regular, design: .default))
                    Button(action: {
//                        nextTapped()
                    }) {
                        buttonText
                    }
                    Text("By continuing you accept our Terms of Use and Privacy Policy")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding([.leading, .trailing], 50)
                }
                
                Spacer()
                    .frame(height: 25)
            }
            .padding([.leading, .trailing], 25)
        }
    }
}

struct NewPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NewPurchaseView()
    }
}
