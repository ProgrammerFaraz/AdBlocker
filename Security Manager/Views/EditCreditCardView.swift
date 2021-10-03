//
//  AddCreditCardView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 24.08.2021.
//

import SwiftUI
import Combine
import AnyFormatKitSwiftUI
import AnyFormatKit

struct EditCreditCardView: View {
    
    let formatterCardNumber = DefaultTextFormatter(textPattern: "#### #### #### ####")
    let formatterCardDate = DefaultTextFormatter(textPattern: "##/##")
    
    let cardColors = [
        Colors.blueColor,
        Colors.greenBlueColor,
        Colors.greenColor,
        Colors.yellowColor,
        Colors.pinkColor,
        Colors.orangeColor,
        Colors.purpleColor,
        Colors.redColor
    ]
    
    @Binding var isShowingCardAddView: Bool
    @ObservedObject var wallet: Wallet
    @StateObject var card: Card = Card(backgroundColor: Colors.yellowColor, yOffset: 0)
    @StateObject var test = TestObject()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("CARD NUMBER:")
                .opacity(0.2)
                .font(.system(size: 15))
            FormatTextField(unformattedText: $card.number, placeholder: "XXXX XXXX XXXX XXXX",
                            textPattern: "#### #### #### ####")
                .foregroundColor(Color.white)
                .font(.system(size: 20, design: .monospaced))
                .padding(8)
                .background(Color.white.opacity(0.02))
                .keyboardType(.numberPad)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 2)
                )
            Spacer().frame(height: 25)
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("EXPIRY DATE:")
                        .opacity(0.2)
                        .font(.system(size: 15))
                    FormatTextField(unformattedText: $card.date, placeholder: "XX/XX",
                                    textPattern: "##/##")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, design: .monospaced))
                        .padding(8)
                        .background(Color.white.opacity(0.02))
                        .keyboardType(.numberPad)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 2)
                        )
                }
                VStack(alignment: .leading) {
                    Text("CVV:")
                        .opacity(0.2)
                        .font(.system(size: 15))
                    FormatTextField(unformattedText: $card.cvv, placeholder: "XXX",
                                    textPattern: "###")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, design: .monospaced))
                        .padding(8)
                        .background(Color.white.opacity(0.02))
                        .keyboardType(.numberPad)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 2)
                        )
                }
            }
            Spacer().frame(height: 25)
            Text("OWNER NAME:")
                .opacity(0.2)
                .font(.system(size: 15))
            TextField("", text: $card.owner)
                .font(.system(size: 20))
                .padding(8)
                .background(Color.white.opacity(0.02))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 2)
                )
            Spacer().frame(height: 45)
            HStack() {
                Button(action: {
                    withAnimation(.spring()) {
                        isShowingCardAddView.toggle()
                    }
                }, label: {
                    Text("Cancel")
                        .bold()
                        .fill(alignment: .center)
                })
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                
                Button(action: {
                    card.number = formatterCardNumber.format($card.number.wrappedValue) ?? ""
                    card.date = formatterCardDate.format($card.date.wrappedValue) ?? ""
                    
                    withAnimation(.spring()) {
                        if wallet.cards.contains(card) {
                            print("edited card")
                        } else {
                            wallet.cards.append(card)
                        }
                        isShowingCardAddView.toggle()
                    }
                }, label: {
                    Text("Save")
                        .bold()
                        .fill(alignment: .center)
                })
                .background(Colors.blueColor)
                .cornerRadius(12)
            }
            .frame(height: 45)
            .font(.custom(FontNames.exo, size: 18))
            
        }
        .padding()
        .foregroundColor(.white)
        .background(Colors.bgColor)
        .cornerRadius(20)
        .onAppear() {
            card.backgroundColor = cardColors.randomElement() ?? .white
        }
    }
}

struct AddCreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCreditCardView(isShowingCardAddView: .constant(true), wallet: Wallet(), card: Card(backgroundColor: .blue, yOffset: 0)).previewLayout(.sizeThatFits)
    }
}

class TestObject: ObservableObject {
    @Published var value: String = ""
}


enum CreditCardFormaterType {
    case number, data, cvv
}

class CreditCardNumberFormatter: Formatter {
    var mask = ""
    
    init(_ type: CreditCardFormaterType) {
        super.init()
        switch type {
        case .number:
            mask = "#### #### #### ####"
        case .cvv:
            mask = "###"
        case .data:
            mask = "##/##"
        default:
            mask = ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return formattedAddress(mac: string)
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject?
        return true
    }
    
    func formattedAddress(mac: String?) -> String? {
        guard let number = mac else { return nil }
        let mask = "#### #### #### ####"
        var result = ""
        var index = number.startIndex
        for ch in mask where index < number.endIndex {
            if ch == "#" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
