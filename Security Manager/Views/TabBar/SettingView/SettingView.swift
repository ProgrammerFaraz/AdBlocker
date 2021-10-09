import SwiftUI

struct SettingData: Identifiable {
    let id = UUID()
    let title: String
    let isOn: Bool?
    let image: String?
    let whiteBlackList: Bool
}

struct SettingListData: Identifiable {
    var id: Int
    let header: String
    let settingData: [SettingData]
}

struct SettingRow: View {
    var setting: SettingData
    @State private var toggleOn = false
    
    var body: some View {
        HStack() {
//            if setting.whiteBlackList {
//                if setting.title.contains("White List") {
//                    NavigationLink(destination: BlackWhiteListView(type: .whiteList)) {
//                        Spacer()
//                            .frame(width: 2)
//                        if let image = setting.image {
//                            Image(image)
//                        }
//                        Text(setting.title)
//                        Spacer()
//                        if setting.isOn != nil {
//                            Toggle("", isOn: $toggleOn)
//                                .toggleStyle(SwitchToggleStyle(tint: .green))
//                                .labelsHidden()
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }else {
//                    NavigationLink(destination: BlackWhiteListView(type: .blackList)) {
//                        Spacer()
//                            .frame(width: 2)
//                        if let image = setting.image {
//                            Image(image)
//                        }
//                        Text(setting.title)
//                        Spacer()
//                        if setting.isOn != nil {
//                            Toggle("", isOn: $toggleOn)
//                                .toggleStyle(SwitchToggleStyle(tint: .green))
//                                .labelsHidden()
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }else{
                
                
                Spacer()
                    .frame(width: 2)
                if let image = setting.image {
                    Image(image)
                }
                Text(setting.title)
                Spacer()
                if setting.isOn != nil {
                    Toggle("", isOn: $toggleOn)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .labelsHidden()
                }
//            }
        }
    }
}

struct SettingView: View {

    let settings = [
        SettingData(title: "Block ads", isOn: false, image: ("block_annoyances"), whiteBlackList: false)
    ]
    let settingsAdvanced = [
        SettingData(title: "Block Tracking", isOn: false, image: ("block_annoyances"), whiteBlackList: false),
        SettingData(title: "Block Adult Sites", isOn: false, image: ("18+"), whiteBlackList: false),
        SettingData(title: "Block Social Buttons", isOn: false, image: ("block_social"), whiteBlackList: false),
        SettingData(title: "Block Annoyances", isOn: false, image: ("block_annoyances"), whiteBlackList: false),
        SettingData(title: "Block Comments", isOn: false, image: ("block_comment"), whiteBlackList: false)
    ]
    let settingsResourcers = [
        SettingData(title: "Block Images", isOn: false, image: ("block_images"), whiteBlackList: false),
        SettingData(title: "Block Custom Fonts", isOn: false, image: ("block_fonts"), whiteBlackList: false),
        SettingData(title: "Block Scripts", isOn: false, image: ("block_scripts"), whiteBlackList: false),
        SettingData(title: "Block Style Sheets", isOn: false, image: ("block_stylesheets"), whiteBlackList: false)
    ]
    let settingsFilters = [
        SettingData(title: "White List", isOn: nil, image: ("whitelist"), whiteBlackList: true),
        SettingData(title: "Black List", isOn: nil, image: ("blacklist"), whiteBlackList: true)
    ]
    let settingsAccount = [
        SettingData(title: "Privacy Policy", isOn: nil, image: nil, whiteBlackList: false),
        SettingData(title: "Terms of Use", isOn: nil, image: nil, whiteBlackList: false),
        SettingData(title: "Rate Us", isOn: nil, image: nil, whiteBlackList: false)
    ]
    
    
    var body: some View {
        let setting = setupData()
//        VStack() {
//            HStack(){
//                Spacer()
//                Text("Ad Blocker")
//                    .font(.title)
//                Spacer()
//            }
        NavigationView {
            List {
                ForEach(setting) { setting in
                    Section(header: Text(setting.header)) {
                        ForEach(setting.settingData) { item in
                            if item.whiteBlackList{
                                if item.title.contains("White List"){
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
                                
                            }else {
                                SettingRow(setting: item)
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
            //            Spacer()
//        }
        
    }
    
    func setupData() -> [SettingListData] {
        let settingList = [
            SettingListData(id: 1, header: "", settingData: settings),
            SettingListData(id: 2, header: "Advanced", settingData: settingsAdvanced),
            SettingListData(id: 3, header: "Resourcers", settingData: settingsResourcers),
            SettingListData(id: 4, header: "Filters", settingData: settingsFilters),
            SettingListData(id: 5, header: "Account Settings", settingData: settingsAccount)
        ]
        return settingList
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
