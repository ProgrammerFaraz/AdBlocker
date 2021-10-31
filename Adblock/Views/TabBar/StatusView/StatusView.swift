
import SwiftUI
import Drops

struct StatusView: View {
    
//    @State private var toggleOn = false
    @State var isActivated: Bool = true
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var showingPurchaseView = true
    @State var filter = Constants.filtersSources[0]
    @State var isActive = false
    @State var isNotSubscribedUser: Bool = false
    @State var isTrialExist: Bool? = nil
    @State var trialOverAndNotSubscribed: Bool = false
    
    let firstOpenDate = UserDefaults.standard.object(forKey: "FirstOpen") as? Date
    
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
            Spacer().frame(height: 110)
//            if #available(iOS 14.0, *) {
//                VStack {
//                    Spacer()
//                    if !isActivated {
//                        Spacer()
//                        MTSlideToOpen(thumbnailTopBottomPadding: 4,
//                                      thumbnailLeadingTrailingPadding: 4,
//                                      text: "Slide to Save",
//                                      textColor: .white,
//                                      thumbnailColor: Color.white,
//                                      sliderBackgroundColor: Colors.greenColor,
//                                      didReachEndAction: { view in
//                                        if !BlockManager.shared.isExtensionActive {
//                                            showingHintView = true
//                                            view.resetState()
//                                        } else {
//                                            view.isLoading = true
//                                            BlockManager.shared.activateBlockFilters { error in
//                                                view.isLoading = false
//                                                if error != nil {
//                                                    Drops.show(Drop(title: error!.localizedDescription))
//                                                    view.resetState()
//                                                } else {
//                                                    withAnimation() {
//                                                        isActivated = true
//                                                    }
//                                                }
//                                            }
//                                        }
//                                      })
//                            .transition(.opacity)
//                            .animation(.default)
//                            .frame(width: 320, height: 56)
//                            .cornerRadius(28)
//                            .padding()
//                            .background(Color.white.opacity(0.06))
//                            .background(Colors.bgColor)
//                            .cornerRadius(42)
//                            .shadow(radius: 30)
//                        Spacer().frame(height: 40)
//                    }
//                }
//                .ignoresSafeArea()
//            } else {
//                // Fallback on earlier versions
//            }
        }
        .onAppear() {
            isNotSubscribedUser = !(UserDefaults.standard.bool(forKey: "isBuyed"))
            if let firstOpenDate = firstOpenDate {
                if isPassedMoreThan(days: 3, fromDate: firstOpenDate, toDate: Date()) {
                    isTrialExist = false
                }else {
                    isTrialExist = true
                }
            }
            
            if !BlockManager.shared.isFiltersDownloaded() {
                showingDownloadFiltersView = true
            }
            BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
            })
            
            if !isActivated {
                if !BlockManager.shared.isExtensionActive {
                    showingHintView = true
                } else {
                    BlockManager.shared.activateBlockFilters { error in
                        if error != nil {
                            Drops.show(Drop(title: error!.localizedDescription))
                        } else {
                            withAnimation() {
                                isActivated = true
                            }
                        }
                    }
                }
            }
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
//                if !value {
//                    BlockManager.shared.deactivateFilters { _ in }
//                }else{
//                    BlockManager.shared.activateBlockFilters { _ in }
//                }
            }
        })
//        .onChange(of: isActivated, perform: { value in
//            if !value {
//                //BlockManager.shared.deactivateFilters { _ in }
//            }
//        })
        .onChange(of: isTrialExist, perform: { value in
            print("isTrialExist = \(value)")
            self.trialOverAndNotSubscribed = !(value ?? false) && self.isNotSubscribedUser
        })
        .onChange(of: trialOverAndNotSubscribed, perform: { (value) in
            print("trialOverAndNotSubscribed = \(value)")
        })
        .sheet(isPresented: $showingDownloadFiltersView) {
            WelcomeAndDownloadFiltersView()
        }
        .sheet(isPresented: $showingHintView) {
            HintView()
        }
//        .sheet(isPresented: $showingPurchaseView) {
//            PurchaseView()
//        }
        .sheet(isPresented: $trialOverAndNotSubscribed) {
            NewPurchaseView()
        }
    }
    
    private func isPassedMoreThan(days: Int, fromDate date : Date, toDate date2 : Date) -> Bool {
        let unitFlags: Set<Calendar.Component> = [.day]
        let deltaD = Calendar.current.dateComponents( unitFlags, from: date, to: date2).day
        return (deltaD ?? 0 > days)
    }
}

//struct StatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusView(isActivated: )
//    }
//}
