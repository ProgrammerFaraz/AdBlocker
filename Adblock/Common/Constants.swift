//
//  Constants.swift
//  https://apphud.com
//
//  Created by Apphud on 22/06/2019.
//  Copyright © 2019 apphud. All rights reserved.
//

import Foundation

let monthlySubscription = "pro_2999_1m_3d0"
let yearlySubscription = "pro_5999_1y_3days0"
let shared_secret = "cf1337083b604bad94572d8bdc85a541"

let terms_text = "Premium subscription is required to get access to all wallpapers. Regardless whether the subscription has free trial period or not it automatically renews with the price and duration given above unless it is canceled at least 24 hours before the end of the current period. Payment will be charged to your Apple ID account at the confirmation of purchase. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."

struct Constants {
    
    static let showLoaderNotification = "showLoader"
    static let activateSuccessMsg = "Filter activated Successfully"
    static let deactivateSuccessMsg = "Filter deactivated Successfully"

//    func setup() -> [SettingListData] {
//        let settings = [
//            FilterSource(name: Constants.filtersSources[0].name, url: Constants.filtersSources[0].url, description: Constants.filtersSources[0].description, free: Constants.filtersSources[0].free, imageName: Constants.filtersSources[0].imageName, color: Constants.filtersSources[0].color, whiteBlackList: false, fileName: Constants.filtersSources[0].fileName)
//        ]
//        var settingsAdvanced = [FilterSource]()
//        for i in 1..<(Constants.filtersSources.count) {
//            settingsAdvanced.append(FilterSource(name: Constants.filtersSources[i].name, url: Constants.filtersSources[i].url, description: Constants.filtersSources[i].description, free: Constants.filtersSources[i].free, imageName: Constants.filtersSources[i].imageName, color: Constants.filtersSources[i].color, whiteBlackList: false, fileName: Constants.filtersSources[i].fileName))
//        }
//        let settingsFilters = [
//            FilterSource(name: "White List", url: "", description: "", free: true, imageName: "whitelist", color: Colors.bgColor!, whiteBlackList: true, fileName: ""),
//            FilterSource(name: "Black List", url: "", description: "", free: true, imageName: "blacklist", color: Colors.bgColor!, whiteBlackList: true, fileName: "")
//        ]
//        let settingsAccount = [
//            FilterSource(name: "Privacy Policy", url: "", description: "", free: true, imageName: "", color: Colors.bgColor!, whiteBlackList: true, fileName: ""),
//            FilterSource(name: "Terms of Use", url: "", description: "", free: true, imageName: "", color: Colors.bgColor!, whiteBlackList: true, fileName: ""),
//            FilterSource(name: "Rate Us", url: "", description: "", free: true, imageName: "", color: Colors.bgColor!, whiteBlackList: true, fileName: "")
//        ]
//        let settingListData = [
//            SettingListData(id: 1, header: "", settingData: settings),
//            SettingListData(id: 2, header: "Advanced", settingData: settingsAdvanced),
//            SettingListData(id: 3, header: "Filters", settingData: settingsFilters),
//            SettingListData(id: 4, header: "Account Settings", settingData: settingsAccount)
//        ]
//        return settingListData
//    }
    static let revenueAPIKey = "ZFjLdoXwbhReJXHUjmmjmprjuvOFMVwb"
    static let filtersSources: [FilterSource] = [
        FilterSource(name: "Block Mobile Ads",
                     url: "https://gitlab.com/eyeo/adblockplus/adblock-plus-for-safari/-/raw/main/AdblockPlusSafari/Assets/easylist_content_blocker.json",
                     description: "Filter blocks mobile ad networks",
                     free: true,
                     imageName: "safari.fill",
                     color: Colors.blueColor,
                     whiteBlackList: false,
                     defaultActivate: false,
                     isRawJson: true),
        FilterSource(name: "User Reporting Filter",
                     url: "https://ads-protector.com/blocksite/custom.txt",
                     description: "Filter blocks mobile ad networks",
                     free: true,
                     imageName: "safari.fill",
                     color: Colors.blueColor,
                     whiteBlackList: false,
                     defaultActivate: false,
                     isRawJson: false),
//        FilterSource(name: "Block Tracking Tools",
//                     url: "https://filters.adtidy.org/ios/filters/3_optimized.txt",
//                     description: "Filter blocks web analytics tools that track your online activities.",
//                     free: false,
//                     imageName: "hand.raised.slash.fill",
//                     color: Colors.redColor,
//                     whiteBlackList: false,
//                     defaultActivate: true,
//                     isRawJson: false),
//        FilterSource(name: "Block Irritating Element",
//                     url: "https://filters.adtidy.org/ios/filters/14_optimized.txt",
//                     description: "Filter blocks in-page pop-ups and third-party widgets on websites.",
//                     free: false,
//                     imageName: "flame.fill",
//                     color: Colors.yellowColor,
//                     whiteBlackList: false,
//                     defaultActivate: true,
//                     isRawJson: false),
        FilterSource(name: "Block Russian Language Websites",
                     url: "https://ads-protector.com/blocksite/russian.txt",
                     description: "Filter blocks ads on Russian-language sites.",
                     free: false,
                     imageName: "flag.fill",
                     color: Colors.greenBlueColor,
                     whiteBlackList: false,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Block German Language Websites",
                     url: "https://ads-protector.com/blocksite/german.txt",
                     description: "Filter blocks ads on German-language sites.",
                     free: false,
                     imageName: "flag.fill",
                     color: Colors.purpleColor,
                     whiteBlackList: false,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Block Spanish & Portuguese Language Websites",
                     url: "https://ads-protector.com/blocksite/spanish.txt",
                     description: "Filter blocks ads on Spanish/Portuguese sites.",
                     free: false,
                     imageName: "flag.fill",
                     color: Colors.greenColor,
                     whiteBlackList: false,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Block French Language Website",
                     url: "https://ads-protector.com/blocksite/french.txt",
                     description: "Filter blocks ads on French sites.",
                     free: false,
                     imageName: "flag.fill",
                     color: Colors.orangeColor,
                     whiteBlackList: false,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "White List",
                     url: "",
                     description: "",
                     free: true,
                     imageName: "whitelist",
                     color: Colors.bgColor!,
                     whiteBlackList: true,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Black List",
                     url: "",
                     description: "",
                     free: true,
                     imageName: "blacklist",
                     color: Colors.bgColor!,
                     whiteBlackList: true,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Privacy Policy",
                     url: "",
                     description: "",
                     free: true,
                     imageName: "",
                     color: Colors.bgColor!,
                     whiteBlackList: true,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Terms of Use",
                     url: "",
                     description: "",
                     free: true,
                     imageName: "",
                     color: Colors.bgColor!,
                     whiteBlackList: true,
                     defaultActivate: false,
                     isRawJson: false),
        FilterSource(name: "Rate Us",
                     url: "",
                     description: "",
                     free: true,
                     imageName: "",
                     color: Colors.bgColor!,
                     whiteBlackList: true,
                     defaultActivate: false,
                     isRawJson: false)
    ]
    static let settingListData = [
        SettingListData(id: 1,
                        header: "",
                        settingData: [FilterSource(name: "Block Mobile Ads",
                                                   url: "https://gitlab.com/eyeo/adblockplus/adblock-plus-for-safari/-/raw/main/AdblockPlusSafari/Assets/easylist_content_blocker.json",
                                                   description: "Filter blocks mobile ad networks",
                                                   free: true,
                                                   imageName: "safari.fill",
                                                   color: Colors.blueColor,
                                                   whiteBlackList: false,
                                                   defaultActivate: false,
                                                   isRawJson: false)]),
        SettingListData(id: 2,
                        header: "Advanced",
                        settingData: [FilterSource(name: "User Reporting Filter",
                                                   url: "https://ads-protector.com/blocksite/custom.txt",
                                                   description: "Filter blocks mobile ad networks",
                                                   free: true,
                                                   imageName: "safari.fill",
                                                   color: Colors.blueColor,
                                                   whiteBlackList: false,
                                                   defaultActivate: false,
                                                   isRawJson: false),
//                                      FilterSource(name: "Block Tracking Tools",
//                                                   url: "https://filters.adtidy.org/ios/filters/3_optimized.txt",
//                                                   description: "Filter blocks web analytics tools that track your online activities.",
//                                                   free: false,
//                                                   imageName: "hand.raised.slash.fill",
//                                                   color: Colors.redColor,
//                                                   whiteBlackList: false,
//                                                   defaultActivate: true,
//                                                   isRawJson: false),
//                                      FilterSource(name: "Block Irritating Element",
//                                                   url: "https://filters.adtidy.org/ios/filters/14_optimized.txt",
//                                                   description: "Filter blocks in-page pop-ups and third-party widgets on websites.",
//                                                   free: false,
//                                                   imageName: "flame.fill",
//                                                   color: Colors.yellowColor,
//                                                   whiteBlackList: false,
//                                                   defaultActivate: true,
//                                                   isRawJson: false),
                                      FilterSource(name: "Block Russian Language Websites",
                                                   url: "https://ads-protector.com/blocksite/russian.txt",
                                                   description: "Filter blocks ads on Russian-language sites.",
                                                   free: false,
                                                   imageName: "flag.fill",
                                                   color: Colors.greenBlueColor,
                                                   whiteBlackList: false,
                                                   defaultActivate: false,
                                                   isRawJson: false),
                                      FilterSource(name: "Block German Language Websites",
                                                   url: "https://ads-protector.com/blocksite/german.txt",
                                                   description: "Filter blocks ads on German-language sites.",
                                                   free: false,
                                                   imageName: "flag.fill",
                                                   color: Colors.purpleColor,
                                                   whiteBlackList: false,
                                                   defaultActivate: false,
                                                   isRawJson: false),
                                      FilterSource(name: "Block Spanish & Portuguese Language Websites",
                                                   url: "https://ads-protector.com/blocksite/spanish.txt",
                                                   description: "Filter blocks ads on Spanish/Portuguese sites.",
                                                   free: false,
                                                   imageName: "flag.fill",
                                                   color: Colors.greenColor,
                                                   whiteBlackList: false,
                                                   defaultActivate: false,
                                                   isRawJson: false),
                                      FilterSource(name: "Block French Language Website",
                                                   url: "https://ads-protector.com/blocksite/french.txt",
                                                   description: "Filter blocks ads on French sites.",
                                                   free: false,
                                                   imageName: "flag.fill",
                                                   color: Colors.orangeColor,
                                                   whiteBlackList: false,
                                                   defaultActivate: false,
                                                   isRawJson: false)
                        ]),
        SettingListData(id: 3,
                        header: "Filters",
                        settingData: [FilterSource(name: "White List",
                                                   url: "",
                                                   description: "",
                                                   free: true,
                                                   imageName: "whitelist",
                                                   color: Colors.bgColor!,
                                                   whiteBlackList: true,
                                                   defaultActivate: false,
                                                   isRawJson: false),
                                      FilterSource(name: "Black List",
                                                   url: "",
                                                   description: "",
                                                   free: true,
                                                   imageName: "blacklist",
                                                   color: Colors.bgColor!,
                                                   whiteBlackList: true,
                                                   defaultActivate: false,
                                                   isRawJson: false)]),
        SettingListData(id: 4,
                        header: "Account Settings",
                        settingData: [FilterSource(name: "Privacy Policy",
                                                   url: "",
                                                   description: "",
                                                   free: true,
                                                   imageName: "",
                                                   color: Colors.bgColor!,
                                                   whiteBlackList: true,
                                                   defaultActivate: false,
                                                   isRawJson: false),
                                      FilterSource(name: "Terms of Use",
                                                   url: "",
                                                   description: "",
                                                   free: true,
                                                   imageName: "",
                                                   color: Colors.bgColor!,
                                                   whiteBlackList: true,
                                                   defaultActivate: false,
                                                   isRawJson: false),
                                      FilterSource(name: "Rate Us",
                                                   url: "",
                                                   description: "",
                                                   free: true,
                                                   imageName: "",
                                                   color: Colors.bgColor!,
                                                   whiteBlackList: true,
                                                   defaultActivate: false,
                                                   isRawJson: false)
                        ])
    ]
    struct Links {
        static let privacyPolicy = "https://www.superagentdefense.com/?page_id=7"
        static let termsOfUse = "https://www.superagentdefense.com/?page_id=13"
    }
    static let supportEmail = "support@superagentdefense.com"
    
    static let monthlyPrice = "29.99 / Month"
    static let yearlyPrice = "59.99 / Year"
    static let monthlyPriceDescription = "Per Month, auto renewal"
    static let yearlyPriceDescription = "Per Year, auto renewal"
}
