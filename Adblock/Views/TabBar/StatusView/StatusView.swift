
import SwiftUI
import Drops
import ActivityIndicatorView
import Purchases

class ActiveSheet {
    static var shared = ActiveSheet()
    private init() {}
    var type: String = ""
}

struct StatusView: View {
    
//    @State private var toggleOn = false
    @State private var showSheet = false
//    @State private var activeSheet: ActiveSheet?

    @State var isActivated: Bool = true
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var showingPurchaseView = true
    @State var filter = Constants.filtersSources[0]
    @State var isActive = false
    @State var isNotSubscribedUser: Bool = false
    @State var isTrialExist: Bool? = nil
    @State var trialOverAndNotSubscribed: Bool = false
    @State var products: [Purchases.Package] = []

    @State var showLoadingIndicator = false
    
    let firstOpenDate = UserDefaults.standard.object(forKey: "FirstOpen") as? Date
    
    var body: some View {
//        ZStack {
//            LoadingView(isShowing: $showLoadingIndicator) {
                VStack {
                    if isActive {
                        Image(uiImage: UIImage(named: "logo")!)
                            .resizable()
                            .frame(width: 150, height: 180)
                        Text("YOU ARE PROTECTED")
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }else {
                        Image(uiImage: UIImage(named: "logo_gray")!)
                            .resizable()
                            .frame(width: 150, height: 180)
                        Text("YOU ARE NOT PROTECTED")
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
        //            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .rotatingDots)
                    Spacer()
                        .frame(height: 50)
                    Toggle("", isOn: $isActive)
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                    .labelsHidden()
                    Spacer().frame(height: 110)
                }
//            }
//            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .flickeringDots)
//                .frame(width: 150, height: 180)
            
//        }
        .onAppear() {
            
            if !BlockManager.shared.isFiltersDownloaded() {
//                self.activeSheet = .downloadFilter
                ActiveSheet.shared.type = "download"
                self.showSheet = true
            }
            else {
                isNotSubscribedUser = !(UserDefaults.standard.bool(forKey: "isBuyed"))
                if let firstOpenDate = firstOpenDate {
                    fetchPackages() {
                        packages in
                        print(packages)
                        self.products = packages
                        //                self.selectedProduct = self.products[0]
                        if isPassedMoreThan(days: 3, fromDate: firstOpenDate, toDate: Date()) {
                            isTrialExist = false
                        }else {
                            isTrialExist = true
                        }
                    }
                }
                BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
                    if !result {
                        BlockManager.shared.deactivateFilters { error in
                            if error != nil {
                                Drops.hideCurrent()
                                Drops.show(Drop(title: error!.localizedDescription, duration: 2.0))
                            } else {
                                Drops.hideCurrent()
                                Drops.show(Drop(title: Constants.deactivateSuccessMsg, duration: 2.0))
                                withAnimation() {
                                    isActivated = true
                                }
                            }
                        }
                    }
                    if !result {
                        if !BlockManager.shared.isExtensionActive {
                            showingHintView = true
                        }
                    }
                })
            }
        }
        .onChange(of: isActive, perform: { value in
            if value != filter.activate {
                isActivated = false
                filter.activate = value
                if !value {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": true])
//                    showLoadingIndicator = true
                    BlockManager.shared.deactivateFilters { error in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
//                        showLoadingIndicator = false
                        if error != nil {
                            Drops.hideCurrent()
                            Drops.show(Drop(title: error!.localizedDescription, duration: 2.0))
                        } else {
                            Drops.hideCurrent()
                            Drops.show(Drop(title: Constants.deactivateSuccessMsg, duration: 2.0))
                            withAnimation() {
                                isActivated = true
                            }
                        }
                    }
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": true])
//                    showLoadingIndicator = true
                    BlockManager.shared.getActivationState { value in
                        print("🔥 \(value)")
                        if value {
                            BlockManager.shared.activateFilters { error in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
        //                        showLoadingIndicator = false
                                if error != nil {
                                    self.isActive = false
                                    Drops.hideCurrent()
                                    Drops.show(Drop(title: error!.localizedDescription, duration: 2.0))
                                } else {
                                    Drops.hideCurrent()
                                    Drops.show(Drop(title: Constants.activateSuccessMsg, duration: 2.0))
                                    withAnimation() {
                                        isActivated = true
                                    }
                                }
                            }
                        } else {
                            self.isActive = false
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
                            self.showSheet = true
                            ActiveSheet.shared.type = "hint"
                        }
                    }
                    
                }
            }
        })
//        .onChange(of: isActivated, perform: { value in
//            if !value {
//                BlockManager.shared.deactivateFilters { error in
//                    if error != nil {
//                        Drops.show(Drop(title: error!.localizedDescription))
//                    } else {
//                        Drops.show(Drop(title: Constants.deactivateSuccessMsg))
//                        withAnimation() {
//                            isActivated = true
//                        }
//                    }
//                }
//            }
//            if !value {
//                if !BlockManager.shared.isExtensionActive {
//                    showingHintView = true
//                }
//            }
//        })
        .onChange(of: isTrialExist, perform: { value in
            print("isTrialExist = \(value)")
            self.trialOverAndNotSubscribed = !(value ?? false) && self.isNotSubscribedUser
        })
        .onChange(of: trialOverAndNotSubscribed, perform: { (value) in
            if value {
//                self.activeSheet = .purchase
                ActiveSheet.shared.type = "purchase"
                self.showSheet = true
            }
            print("trialOverAndNotSubscribed = \(value)")
        })
        .sheet(isPresented: $showSheet) {
            if ActiveSheet.shared.type == "download" {
                WelcomeAndDownloadFiltersView()
            } else if ActiveSheet.shared.type == "purchase" {
                NewPurchaseView(products: self.products)
            } else if ActiveSheet.shared.type == "hint" {
                HintView()
            }
        }
//        .sheet(isPresented: $showingHintView) {
//            HintView()
//        }
//        .sheet(isPresented: $trialOverAndNotSubscribed) {
//            NewPurchaseView()
//        }
    }
    
    func fetchPackages(completion: @escaping ([Purchases.Package]) -> Void) {
        Purchases.shared.offerings { (offerings, error) in
            guard let offerings = offerings, error == nil else {
                return
            }
            guard let packages = offerings.all.first?.value.availablePackages else { return }
                 completion(packages)
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
