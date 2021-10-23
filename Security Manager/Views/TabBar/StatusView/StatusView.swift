//
//  StatusView.swift
//  Security Manager
//
//  Created by Faraz on 10/2/21.
//

import SwiftUI

struct StatusView: View {
    
//    @State private var toggleOn = false
    @Binding var isActivated: Bool
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var showingPurchaseView = true
    @State var filter = Constants.filtersSources[0]
    @State var isActive = false
    var body: some View {
        
        VStack {
            if isActive {
                Image(uiImage: UIImage(named: "logo_gray")!)
                    .resizable()
                    .frame(width: 150, height: 180)
                Text("YOU ARE PROTECTED")
                    .font(.system(size: 25, weight: .bold, design: .default))
            }else {
                Image(uiImage: UIImage(named: "logo")!)
                    .resizable()
                    .frame(width: 150, height: 180)
                Text("YOU ARE NOT PROTECTED")
                    .font(.system(size: 25, weight: .bold, design: .default))
            }
            Spacer()
                .frame(height: 50)
            Toggle("", isOn: $isActive)
            .toggleStyle(SwitchToggleStyle(tint: .red))
            .labelsHidden()
        }
        .onAppear() {
           
            if !BlockManager.shared.isFiltersDownloaded() {
                showingDownloadFiltersView = true
            }
            BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
            })
            if isActivated {
                isActive = filter.activate
            } else {
                isActive = false
            }
        }
        .onChange(of: isActive, perform: { value in
            if value != filter.activate {
                isActivated = false
                filter.activate = value
                if !value {
                    BlockManager.shared.deactivateFilters { _ in }
                }else{
                    BlockManager.shared.activateBlockFilters { _ in }
                }
            }
        })
//        .onChange(of: isActivated, perform: { value in
//            if !value {
//                //BlockManager.shared.deactivateFilters { _ in }
//            }
//        })
        .sheet(isPresented: $showingDownloadFiltersView) {
            WelcomeAndDownloadFiltersView()
        }
        .sheet(isPresented: $showingHintView) {
            HintView()
        }
        .sheet(isPresented: $showingPurchaseView) {
            NewPurchaseView(selectedPlan: Constants.monthlyPrice, planItems: [Constants.monthlyPrice, Constants.yearlyPrice])
        }
    }
}

//struct StatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusView(isActivated: )
//    }
//}
