//
//  SwiftUIView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 23.08.2021.
//

import SwiftUI
import Drops
import AnyFormatKit

// constants
let cardWidth: CGFloat = 343
let cardHeight: CGFloat = 212
let spacing = 50
let animation = Animation.spring()

class Wallet: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedCard: Card?
    
    func resetCards() {
        // reset the wallet back to its normal state
        print("reset cards")
        
        for (i, card) in self.cards.enumerated() {
            withAnimation(animation) {
                card.yOffset = CGFloat(i * spacing)
            }
        }
    }
    
    func hideOtherCards(card: Card) {
        let cardPadding = spacing
        
        for walletCard in self.cards {
            if walletCard.id == card.id {
                // skip the card we tapped
                continue
            } else {
                walletCard.tapped = false
                withAnimation(animation) {
                    walletCard.flipped = false
                }

                withAnimation(animation) {
                    walletCard.yOffset = cardHeight + CGFloat(cardPadding) + walletCard.yOffset
                }
            }
        }
    }
    
    func tapCard(card: Card) {
        // restore cards to their original positions
        self.resetCards()
        
        if card.tapped {
            card.tapped = false
            
            withAnimation(animation) {
                card.flipped = false
            }
        } else {
            selectedCard = card
            
            card.tapped = true
            withAnimation(animation) {
                // move tapped card to the top
                card.yOffset = 0
            }
            
            hideOtherCards(card: card)
        }
        
    }
}

class Card: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var tapped = false
    @Published var flipped = false
    @Published var backgroundColor: Color
    @Published var yOffset: CGFloat
    
    @Published var number: String = ""
    @Published var date: String = ""
    @Published var cvv: String = ""
    @Published var owner: String = ""
    
    init(backgroundColor: Color, yOffset: CGFloat) {
        self.backgroundColor = backgroundColor
        self.yOffset = yOffset
    }
    
    func randomNumber(digits: Int) -> String {
        // generate random last 4 digits
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
}

struct WalletView: View {
    let walletManager = WalletManager()
    
    @State var isShowingCardAddView = false
    
    @ObservedObject var wallet = Wallet()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .offset(x: -2, y: 2)
                    }).foregroundColor(Colors.blueColor)
                    Text("Bank cards")
                        .foregroundColor(.white)
                        .font(.custom(FontNames.exoSemiBold, size: 22))
                    Spacer()
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                ScrollView {
                    ZStack(alignment: .top) {
                        ForEach(self.wallet.cards, id: \.id) { card in
                            CardView(isShowingCardAddView: $isShowingCardAddView, card: card, wallet: wallet)
                                .tappable(wallet: self.wallet, card: card)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            VStack {
                Spacer()
                if !isShowingCardAddView {
                Button(action: {
                    withAnimation(.spring()) {
                        wallet.selectedCard?.tapped = false
                        wallet.resetCards()
                        isShowingCardAddView.toggle()
                    }
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 40))
                        .padding()
                        .background(Color.white.opacity(0.03))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08), lineWidth: 2)
                        )
                })
                } else {
                    EditCreditCardView(isShowingCardAddView: $isShowingCardAddView, wallet: wallet)
                        .transition(.opacity)
                        .animation(.linear(duration: 0.1))
                        .padding()
                        .shadow(radius: 30)
                }
            }
        }
        .onChange(of: wallet.cards, perform: { _ in
            wallet.resetCards()
            
            walletManager.saveCards(cards: wallet.cards)
        })
        
        .onAppear() {
            wallet.cards = walletManager.loadCards()
        }
    }
}

struct CardView: View {
    @Binding var isShowingCardAddView: Bool
    
    @ObservedObject var card: Card
    @ObservedObject var wallet: Wallet
    
    var flippedToggle: some View {
        HStack {
            if self.card.tapped {
                Button(action: {
                    withAnimation(.spring()) {
                        self.card.flipped.toggle()
                    }
                }) {
                    Image(systemName: self.card.flipped ? "xmark.circle.fill" : "ellipsis.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    var cardFront: some View {
        VStack {
            HStack {
                Text("•••• •••• •••• \(String(card.number.suffix(4)))")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(height: 25)
                Spacer()
                self.flippedToggle
            }
            
            Spacer()
            
            HStack {
                Text(card.owner)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(.white)
                Spacer()
                Image(card.number.first == "4" ? "visa" : "mastercard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 55)
            }
        }
    }
    
    func copyNumber() {
        UIPasteboard.general.string = card.number
        Drops.show(Drop(title: "Card number is copied"))
    }
    
    func copyName() {
        UIPasteboard.general.string = card.owner
        Drops.show(Drop(title: "Owner name is copied"))
    }
    
    func copyDate() {
        UIPasteboard.general.string = card.date
        Drops.show(Drop(title: "Date is copied"))
    }
    
    func copyCVV() {
        UIPasteboard.general.string = card.cvv
        Drops.show(Drop(title: "CVV code is copied"))
    }
    
    var cardBack: some View {
        VStack {
            HStack {
                Button(action: { copyNumber() }) {
                    Text(card.number)
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                }
                Spacer()
                self.flippedToggle
            }
            Spacer()
            HStack {
                Button(action: { copyDate() }) {
                    VStack(spacing: 4) {
                        Text("Date:")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        Text(card.date)
                            .padding(6)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
                    }
                }
                Spacer()
                Button(action: { copyCVV() }) {
                    VStack(spacing: 4) {
                        Text("CVV:")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        Text(card.cvv)
                            .padding(6)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
                    }
                }
            }
            .font(.system(size: 18, weight: .semibold, design: .monospaced))
            .foregroundColor(.white)
            Spacer()
            HStack {
                Button(action: { copyName() }) {
                    Text(card.owner)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(.white)
                }
                Spacer()
//                Button(action: {
//                    isShowingCardAddView.toggle()
//                }, label: {
//                    Text("Edit card")
//                        .font(.system(size: 15, weight: .medium))
//                })
//                .foregroundColor(.white)
//                .padding(8)
//                .background(Color.white.opacity(0.08))
//                .cornerRadius(8)
                Spacer().frame(width: 15)
                Button(action: {
                    withAnimation(.spring()) {
                        wallet.cards.removeAll(where: {$0 == card})
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(4)
        .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
    }
    
    var body: some View {
        VStack {
            VStack {
                if card.flipped {
                    cardBack
                } else {
                    cardFront
                }
            }
            .padding()
            .frame(width: cardWidth, height: cardHeight)
            .background(card.backgroundColor.opacity(0.25))
            .background(Blur(style: .systemUltraThinMaterialDark))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(card.backgroundColor.opacity(1.0), lineWidth: 2)
            )
        }
    }
}


struct TappableView: ViewModifier {
    @ObservedObject var wallet: Wallet
    @ObservedObject var card: Card
    
    func body(content: Content) -> some View {
        content
            .onTapGesture(perform: {
                self.wallet.tapCard(card: self.card)
            })
            .offset(y: card.yOffset)
            //.rotation3DEffect(.degrees(card.tapped ? 0 : isAnyCardTapped() ? -80 : 0), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(card.flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    func isAnyCardTapped() -> Bool {
        for card in self.wallet.cards {
            if card.tapped {
                return true
            }
        }
        
        return false
    }
}

extension View {
    func tappable(wallet: Wallet, card: Card) -> some View {
        return modifier(TappableView(wallet: wallet, card: card))
    }
}



struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
        
        CardView(isShowingCardAddView: .constant(false), card: Card(backgroundColor: Colors.greenColor, yOffset: 0), wallet: Wallet()).previewLayout(.sizeThatFits)
    }
}
