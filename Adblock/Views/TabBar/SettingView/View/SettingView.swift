import SwiftUI
import Drops
import StoreKit
import Purchases

struct SettingRow: View {
    var setting: FilterSource
//    @State private var toggleOn = false
    
    var body: some View {
        HStack() {
                Spacer()
                    .frame(width: 2)
                if let image = setting.imageName {
                    Image(image)
                }
                Text(setting.name)
                Spacer()
//                if setting.isOn != nil {
//                    Toggle("", isOn: $toggleOn)
//                        .toggleStyle(SwitchToggleStyle(tint: .green))
//                        .labelsHidden()
//                }
        }
    }
}

struct SettingRowWithToggle: View {
    
    @Binding var isActivated: Bool
    @State var isShowingDestination = false
    @State var isActive = false
    let filter: FilterSource
    
    @Binding var showSheet: Bool
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 2)
            ZStack {
                filter.color
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(filter.color.opacity(1.0), lineWidth: 2)
                    )
                    .cornerRadius(6)
                    .opacity(0.5)
                Image(systemName: filter.imageName)
                    .font(.system(size: 26))
            }
            Text(filter.name)
            Toggle("", isOn: $isActive)
        }
        .onAppear() {
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": true])
                    BlockManager.shared.deactivateFilters { error in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
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
                    let isSubscribedUser = UserDefaults.standard.bool(forKey: "isBuyed")
                    if isSubscribedUser {
                    BlockManager.shared.getActivationState { value in
                        if value {
                            BlockManager.shared.activateFilters { error in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
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
                            ActiveSheet.shared.type = "hint"
                            self.showSheet = true
                        }
                    }
                    } else {
                        self.isActive = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
                        ActiveSheet.shared.type = "download"
                        self.showSheet = true
                    }
                }
            }
        })
    }
}

struct SettingView: View {
    
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var setting = Constants.settingListData
    @State var isActivated = true
    @State var showSheet = false
    @State var showRateUs = false
    @State var products: [Purchases.Package] = []

    var body: some View {

        NavigationView {
            List {
                ForEach(setting) { (setting) in
                    Section(header: Text(setting.header)) {
                        ForEach(setting.settingData) { item in
                            if item.whiteBlackList{
                                switch item.name {
                                case "White List":
                                    NavigationLink(destination: BlackWhiteListView(type: .whiteList)) {
                                        SettingRow(setting: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                case "Black List":
                                    NavigationLink(destination: BlackWhiteListView(type: .blackList)) {
                                        SettingRow(setting: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                case "Rate Us":
                                    NavigationLink(destination: WebViewPage(request: nil)) {
                                        SettingRow(setting: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                case "Privacy Policy":
                                    NavigationLink(destination: WebViewPage(request: URLRequest(url: URL(string: "https://gsmith.app/privacy-policy")!))) {
                                        SettingRow(setting: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                default:
                                    NavigationLink(destination: WebViewPage(request: URLRequest(url: URL(string: "https://gsmith.app/terms-of-use")!))) {
                                        SettingRow(setting: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            else {
                                SettingRowWithToggle(isActivated: $isActivated, filter: item, showSheet: $showSheet)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack() {
                        Text("Ad Blocker")
                            .font(.headline)
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear() {
            fetchPackages() {
                packages in
                print(packages)
                self.products = packages
                //                self.selectedProduct = self.products[0]
                
            }
            UITabBar.appearance().isHidden = false
            if !BlockManager.shared.isFiltersDownloaded() {
                showingDownloadFiltersView = true
            }
            BlockManager.shared.getActivationState(completion: { result in
                isActivated = result
            })
            if !isActivated {
                if !BlockManager.shared.isExtensionActive {
                    showingHintView = true
                }
            }
        }
        .onChange(of: isActivated, perform: { value in
            if !value {
                //BlockManager.shared.deactivateFilters { _ in }
            }
        })
        .sheet(isPresented: $showSheet) {
            if ActiveSheet.shared.type == "download" {
                WelcomeAndDownloadFiltersView(products: self.products)
            } else if ActiveSheet.shared.type == "purchase" {
                NewPurchaseView(products: self.products)
            } else if ActiveSheet.shared.type == "hint" {
                HintView()
            }
        }
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
//    func rateApp() {
//
//        if let windowScene = appData.window?.windowScene {
//            SKStoreReviewController.requestReview(in: windowScene)
//        }
////        if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1586653169") {
////            if #available(iOS 10, *) {
////                UIApplication.shared.open(url, options: [:], completionHandler: nil)
////
////            } else {
////                UIApplication.shared.openURL(url)
////            }
////        }
//    }
    
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
