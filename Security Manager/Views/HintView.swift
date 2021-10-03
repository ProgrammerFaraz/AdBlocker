//
//  WelcomeAndDownloadFiltersView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 31.08.2021.
//

import SwiftUI
import SafariServices

struct HintView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func checkStats() {
        let id = Config.App.extensionBundleId
        
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id, completionHandler: { state, error in
            DispatchQueue.main.async {
                if state?.isEnabled ?? false {
                    BlockManager.shared.isExtensionActive = true
                    presentationMode.dismiss()
                }
            }
        })
    }
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Activate Sfari AD Block")
                        .font(.custom(FontNames.exoSemiBold, size: 22))
                    Spacer()
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                Spacer()
                
                VStack(alignment: .center) {
                    Spacer()
                    Text("1 - Open settings\n2 - Open «Safari» settings\n3 - Select content blockers\n4 - Activate «Super Agent»")
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 30)
                    Image("hint")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame()
                        .padding()
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(20)
                    Spacer()
                }
                .padding()
            }
            .foregroundColor(.white)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                checkStats()
                
            }
        }
        .font(.custom(FontNames.exo, size: 18))
    }
}

struct HintView_Previews: PreviewProvider {
    static var previews: some View {
        HintView()
    }
}
