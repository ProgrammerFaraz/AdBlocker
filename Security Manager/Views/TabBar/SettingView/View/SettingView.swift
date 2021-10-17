import SwiftUI

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
//                    .shadow(color: filter.color.opacity(0.38), radius: 30, x: 5.0, y: 3.0)
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
            }
        })
    }
}

struct SettingView: View {
    
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var filters = Constants.filtersSources
    @State var isActivated = true

    @State private var viewModel = SettingViewModel()
    var body: some View {
        let setting = viewModel.setupData()
        NavigationView {
            List {
//                ForEach(filters, id: \.url) { filter in
//                    SettingRowWithToggle(isActivated: $isActivated, filter: filter)
//                }
                
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
                                SettingRowWithToggle(isActivated: $isActivated, filter: item)
//                                SettingRow(setting: item)
                            }
                            //                            else {
                            //                                SettingRow(setting: item)
                            //                            }
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
            if !BlockManager.shared.isFiltersDownloaded() {
                showingDownloadFiltersView = true
            }
            
            BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
            })
        }
        .onChange(of: isActivated, perform: { value in
            if !value {
                //BlockManager.shared.deactivateFilters { _ in }
            }
        })
        .sheet(isPresented: $showingDownloadFiltersView) {
            WelcomeAndDownloadFiltersView()
        }
        .sheet(isPresented: $showingHintView) {
            HintView()
        }
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
