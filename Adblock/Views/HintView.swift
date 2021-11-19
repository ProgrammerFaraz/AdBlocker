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
                //FIXME: - Uncomment below if let conditions
                if state?.isEnabled ?? true {
                    BlockManager.shared.isExtensionActive = true
                    presentationMode.dismiss()
                }
//                if let error = error {
//                    print("\n\n 🔥🔥 \(error.localizedDescription) 🔥🔥\n\n")
//                }
//                if let state = state {
//                    if state.isEnabled {
//                        BlockManager.shared.isExtensionActive = true
//                        presentationMode.dismiss()
//                    }
//                }
            }
        })
    }
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Activate Safari Adblock")
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Spacer()
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                Spacer()
                
                VStack(alignment: .center) {
                    Spacer()
                    Text("1 - Open settings\n2 - Go To Safari Settings\n3 - Select Content Blockers/Extensions\n4 - Activate Adblock")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .bold, design: .default))
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
