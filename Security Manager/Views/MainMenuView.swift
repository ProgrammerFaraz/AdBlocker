//
//  MainMenuView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 22.08.2021.
//

import SwiftUI
import GoogleMobileAds

final private class BannerVC: UIViewControllerRepresentable  {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = Config.Ads.banner
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct MainMenuView: View {
    @EnvironmentObject private var passcodeManager: PasscodeManager
    @State var isLocked: Bool = true
    @State var isSubscribeScreenShowing: Bool = false
    @State var isSubscribedUser: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase

    
    private let spacing: CGFloat = 18.0
    
    var gridItems: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 130), spacing: spacing * 0.7), count: 2)
    }
    
    
    var body: some View {
        
        if !passcodeManager.passcodeSet {
            SetPasscodeView { newCode, newLength in
                withAnimation {
                    passcodeManager.passcodeLength = newLength
                    passcodeManager.passcode = newCode
                    isLocked = false
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
        } else {
            NavigationView() {
                ZStack {
                    Colors.bgColor.ignoresSafeArea()
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Security Manager")
                                .foregroundColor(.white)
                                .font(.custom(FontNames.exoSemiBold, size: 30))
                                .padding([.top, .leading, .trailing])
                        }
                        Spacer().frame(height: 18)
                        Color.white.frame(height: 1).opacity(0.08)
                        ScrollView(.vertical, showsIndicators: false) {
                            if !isSubscribedUser { BannerVC().frame(width: 320, height: 50, alignment: .center) }
                            LazyVGrid(columns: gridItems, spacing: spacing) {
                                MenuItemView(color: Colors.greenColor,
                                             name: "Password generator",
                                             description: "Advance tool for creating secure passwords",
                                             iconName: "lock.shield.fill",
                                             destinationID: 0, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                                MenuItemView(color: Colors.blueColor,
                                             name: "Password storage",
                                             description: "Secure encrypted password storage",
                                             iconName: "text.justify",
                                             destinationID: 1, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                                MenuItemView(color: Colors.orangeColor,
                                             name: "Bank cards",
                                             description: "Tool for safe storage and management of your bank cards",
                                             iconName: "creditcard",
                                             destinationID: 2, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                                MenuItemView(color: Colors.pinkColor,
                                             name: "Secure notes",
                                             description: "Encrypted private notes storage",
                                             iconName: "note.text",
                                             destinationID: 3, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                                MenuItemView(color: Colors.greenBlueColor,
                                             name: "Safari AD block",
                                             description: "Powerful and simple-to-use ad blocker with many advanced filters",
                                             iconName: "safari",
                                             destinationID: 4, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                                MenuItemView(color: Colors.redColor,
                                             name: "Website Block",
                                             description: "Unwanted and annoying websites blocker",
                                             iconName: "umbrella.fill",
                                             destinationID: 5, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                                MenuItemView(color: Colors.purpleColor,
                                             name: "Secure browser",
                                             description: "Secure and anonymous web browser",
                                             iconName: "network",
                                             destinationID: 6, isLocked: false, isSubscribeScreenShowing: $isSubscribeScreenShowing, isSubscribedUser: $isSubscribedUser)
                            }
                            .padding()
                            if !isSubscribedUser { BannerVC().frame(width: 320, height: 50, alignment: .center) }
                        }
                    }
                }
                .navigationBarHidden(true)
                .foregroundColor(.white)
            }
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            .overlay(
                Group {
                    if !isLocked {
                        LockView(isLocked: $isLocked)
                            .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .bottom)))
                    }
                }
            )
            .onChange(of: scenePhase) { phase in
                if [.inactive, .background].contains(phase) {
                    isLocked = true
                }
            }
            .onChange(of: isSubscribeScreenShowing, perform: { _ in
                isSubscribedUser = UserDefaults.standard.bool(forKey: "isBuyed")
                print( UserDefaults.standard.bool(forKey: "isBuyed"))
                print(isSubscribedUser)
            })
            .sheet(isPresented: $isSubscribeScreenShowing) {
                PurchaseView()
            }
            .onAppear() {
                isSubscribedUser = UserDefaults.standard.bool(forKey: "isBuyed")
            }
        }
    }
}

struct MenuItemView: View {
    
    let color: Color
    let name: String
    let description: String
    let iconName: String
    let destinationID: Int
    
    @State var isLocked: Bool
    @State var isShowingDestination = false
    @Binding var isSubscribeScreenShowing: Bool
    @Binding var isSubscribedUser: Bool
    
    func getDestinationView() -> AnyView {
        switch destinationID {
        case 0:
            return AnyView(PasswordGeneratorView())
        case 1:
            return AnyView(PasswordListView())
        case 2:
            return AnyView(WalletView())
        case 3:
            return AnyView(NotesView())
        case 4:
            return AnyView(ADBlockView())
        case 5:
            return AnyView(BlackListDomainView())
        case 6:
            return AnyView(BrowserPage())
        default:
            return AnyView(PasswordGeneratorView())
        }
    }
    
    var body: some View {
        HStack {
            ZStack {
                Color.white.opacity(0.02)
                VStack(alignment: .center, spacing: nil){
                    ZStack {
                        color
                            .frame(width: 50, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(color.opacity(1.0), lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .opacity(0.5)
                            .shadow(color: color.opacity(0.38), radius: 30, x: 5.0, y: 3.0)
                        Image(systemName: iconName)
                            .font(.system(size: 26))
                    }
                    Text(name)
                        .multilineTextAlignment(.center)
                        .font(.custom(FontNames.exoMedium, size: 18))
                    Spacer()
                    Text(description)
                        .multilineTextAlignment(.center)
                        .font(.custom(FontNames.exo, size: 14))
                        .opacity(0.5)
                    Spacer()
                }
                .padding()
                .opacity((isLocked && !isSubscribedUser) ? 0.4 : 1.0)
                if (isLocked && !isSubscribedUser) {
                    HStack {
                        Spacer()
                        Text("Only by Subscription")
                            .font(.custom(FontNames.exo, size: 14))
                            .padding(2)
                        Spacer()
                    }
                    .background(Colors.redColor.opacity(0.18))
                    .border(Colors.redColor, width: 2)
                    .rotationEffect(.degrees(45))
                    .offset(x: -30, y: 45)
                    .padding(-10)
                }
                
            }
            .foregroundColor(.white)
            .frame(height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.08), lineWidth: 2)
            )
            .cornerRadius(20.0)
            .onPress {
                if (isLocked && !isSubscribedUser) {
                    isSubscribeScreenShowing.toggle()
                } else {
                    isShowingDestination.toggle()
                }
            }
            NavigationLink("", isActive: $isShowingDestination) {
                getDestinationView().navigationBarHidden(true)
            }
        }
        .onAppear() {
            //isLocked = UserDefaults.standard.bool(forKey: "isBuyed")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .environmentObject(PasscodeManager())
            .colorScheme(.dark)
    }
}
