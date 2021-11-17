
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
    let settingData: [FilterSource]
}
