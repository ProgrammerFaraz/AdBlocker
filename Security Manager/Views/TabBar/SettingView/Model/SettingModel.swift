//
//  SettingModel.swift
//  Security Manager
//
//  Created by Faraz on 10/11/21.
//

import Foundation

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
