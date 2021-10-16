import SwiftUI

struct SettingRow: View {
    var setting: SettingData
    @State private var toggleOn = false
    
    var body: some View {
        HStack() {
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
        }
    }
}

struct SettingView: View {
    
    @State private var viewModel = SettingViewModel()
    var body: some View {
        let setting = viewModel.setupData()
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
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
