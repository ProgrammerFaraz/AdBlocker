import SwiftUI
import Drops

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
                    BlockManager.shared.getActivationState { value in
                        if value {
                            BlockManager.shared.activateFilters { error in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderNotification), object: nil, userInfo: ["value": false])
                                if error != nil {
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
    }
}

struct SettingView: View {
    
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var setting = Constants.settingListData
    @State var isActivated = true
    @State var showSheet = false
    

//    var setting = SettingListData
//    @State private var viewModel = SettingViewModel()
    var body: some View {
//        let setting = viewModel.setupData()
        NavigationView {
            List {
                ForEach(setting) { (setting) in
                    Section(header: Text(setting.header)) {
                        ForEach(setting.settingData) { item in
                            if item.whiteBlackList{
                                if item.name.contains("White List"){
                                    NavigationLink(destination: BlackWhiteListView(type: .whiteList)) {
                                        SettingRow(setting: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }else {
                                    NavigationLink(destination: BlackWhiteListView(type: .blackList)) {
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
            if #available(iOS 14.0, *) {
                VStack {
                    Spacer()
                    if !isActivated {
                        
                        Spacer()
                        MTSlideToOpen(thumbnailTopBottomPadding: 4,
                                      thumbnailLeadingTrailingPadding: 4,
                                      text: "Slide to Save",
                                      textColor: .white,
                                      thumbnailColor: Color.white,
                                      sliderBackgroundColor: Colors.greenColor,
                                      didReachEndAction: { view in
                                        if !BlockManager.shared.isExtensionActive {
                                            showingHintView = true
                                            view.resetState()
                                        } else {
                                            view.isLoading = true
                                            BlockManager.shared.activateFilters { error in
                                                view.isLoading = false
                                                if error != nil {
                                                    Drops.hideCurrent()
                                                    Drops.show(Drop(title: error!.localizedDescription, duration: 2.0))
                                                    view.resetState()
                                                } else {
                                                    Drops.hideCurrent()
                                                    Drops.show(Drop(title: Constants.activateSuccessMsg, duration: 2.0))
                                                    withAnimation() {
                                                        isActivated = true
                                                    }
                                                }
                                            }
                                        }
                                      })
                            .transition(.opacity)
                            .animation(.default)
                            .frame(width: 320, height: 56)
                            .cornerRadius(28)
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .background(Colors.bgColor)
                            .cornerRadius(42)
                            .shadow(radius: 30)
                        Spacer().frame(height: 40)
                    }
                }
                .ignoresSafeArea()
            } else {
                // Fallback on earlier versions
            }
        }
        .onAppear() {
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
//                else {
//                    BlockManager.shared.activateFilters { error in
//                        if error != nil {
//                            Drops.show(Drop(title: error!.localizedDescription))
//                        } else {
//                            Drops.show(Drop(title: Constants.activateSuccessMsg))
//                            withAnimation() {
//                                isActivated = true
//                            }
//                        }
//                    }
//                }
            }
//            else {
//                BlockManager.shared.activateFilters { error in
//                    if error != nil {
//                        Drops.show(Drop(title: error!.localizedDescription))
//                    } else {
//                        Drops.show(Drop(title: Constants.activateSuccessMsg))
//                        withAnimation() {
//                            isActivated = true
//                        }
//                    }
//                }
//            }
        }
        .onChange(of: isActivated, perform: { value in
            if !value {
                //BlockManager.shared.deactivateFilters { _ in }
            }
        })
        .sheet(isPresented: $showSheet) {
            if ActiveSheet.shared.type == "download" {
                WelcomeAndDownloadFiltersView()
            } else if ActiveSheet.shared.type == "purchase" {
                NewPurchaseView()
            } else if ActiveSheet.shared.type == "hint" {
                HintView()
            }
        }
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
