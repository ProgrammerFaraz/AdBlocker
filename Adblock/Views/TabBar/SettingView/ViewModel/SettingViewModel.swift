
import Foundation

class SettingViewModel {
    
    func setupData() -> [SettingListData] {
        let settings = [
            FilterSource(name: Constants.filtersSources[0].name, url: Constants.filtersSources[0].url, description: Constants.filtersSources[0].description, free: Constants.filtersSources[0].free, imageName: Constants.filtersSources[0].imageName, color: Constants.filtersSources[0].color, whiteBlackList: false)
        ]
        var settingsAdvanced = [FilterSource]()
        for i in 1..<(Constants.filtersSources.count) {
            settingsAdvanced.append(FilterSource(name: Constants.filtersSources[i].name, url: Constants.filtersSources[i].url, description: Constants.filtersSources[i].description, free: Constants.filtersSources[i].free, imageName: Constants.filtersSources[i].imageName, color: Constants.filtersSources[i].color, whiteBlackList: false))
        }
//            SettingData(title: "Block Adult Sites", isOn: false, image: ("18+"), whiteBlackList: false),
//            SettingData(title: "Block Social Buttons", isOn: false, image: ("block_social"), whiteBlackList: false),
//            SettingData(title: "Block Annoyances", isOn: false, image: ("block_annoyances"), whiteBlackList: false),
//            SettingData(title: "Block Comments", isOn: false, image: ("block_comment"), whiteBlackList: false)
//        ]
//        let settingsResourcers = [
//            SettingData(title: "Block Images", isOn: false, image: ("block_images"), whiteBlackList: false),
//            SettingData(title: "Block Custom Fonts", isOn: false, image: ("block_fonts"), whiteBlackList: false),
//            SettingData(title: "Block Scripts", isOn: false, image: ("block_scripts"), whiteBlackList: false),
//            SettingData(title: "Block Style Sheets", isOn: false, image: ("block_stylesheets"), whiteBlackList: false)
//        ]
        let settingsFilters = [
            FilterSource(name: "White List", url: "", description: "", free: true, imageName: "whitelist", color: Colors.bgColor!, whiteBlackList: true),
            FilterSource(name: "Black List", url: "", description: "", free: true, imageName: "blacklist", color: Colors.bgColor!, whiteBlackList: true)
        ]
        let settingsAccount = [
            FilterSource(name: "Privacy Policy", url: "", description: "", free: true, imageName: "", color: Colors.bgColor!, whiteBlackList: true),
            FilterSource(name: "Terms of Use", url: "", description: "", free: true, imageName: "", color: Colors.bgColor!, whiteBlackList: true),
            FilterSource(name: "Rate Us", url: "", description: "", free: true, imageName: "", color: Colors.bgColor!, whiteBlackList: true)
        ]
        let settingList = [
            SettingListData(id: 1, header: "", settingData: settings),
            SettingListData(id: 2, header: "Advanced", settingData: settingsAdvanced),
            SettingListData(id: 3, header: "Filters", settingData: settingsFilters),
            SettingListData(id: 4, header: "Account Settings", settingData: settingsAccount)
        ]
        return settingList
    }
}
