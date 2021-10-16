//
//  SettingViewModel.swift
//  Security Manager
//
//  Created by Faraz on 10/12/21.
//

import Foundation

class SettingViewModel {
    
    func setupData() -> [SettingListData] {
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
