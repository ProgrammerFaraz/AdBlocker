//
//  Constants.swift
//  https://apphud.com
//
//  Created by Apphud on 22/06/2019.
//  Copyright © 2019 apphud. All rights reserved.
//

import Foundation

let subscription_1 = "week7"
let subscription_2 = "month30"
let shared_secret = "cf1337083b604bad94572d8bdc85a541"

let terms_text = "Premium subscription is required to get access to all wallpapers. Regardless whether the subscription has free trial period or not it automatically renews with the price and duration given above unless it is canceled at least 24 hours before the end of the current period. Payment will be charged to your Apple ID account at the confirmation of purchase. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."

struct Constants {
    static let revenueAPIKey = "ZFjLdoXwbhReJXHUjmmjmprjuvOFMVwb"
    static let filtersSources: [FilterSource] = [
        FilterSource(name: "Block Mobile Ads",
                     url: "https://filters.adtidy.org/ios/filters/11_optimized.txt",
                     description: "Filter blocks mobile ad networks",
                     free: true,
                     imageName: "safari.fill", color: Colors.blueColor, whiteBlackList: false),
        FilterSource(name: "Block Mobile Ads 2",
                     url: "https://gitlab.com/eyeo/adblockplus/adblock-plus-for-safari/-/raw/main/AdblockPlusSafari/Assets/easylist_content_blocker.json",
                     description: "Filter blocks mobile ad networks",
                     free: true,
                     imageName: "safari.fill", color: Colors.blueColor, whiteBlackList: false),
        FilterSource(name: "Block Tracking Tools",
                     url: "https://filters.adtidy.org/ios/filters/3_optimized.txt",
                     description: "Filter blocks web analytics tools that track your online activities.",
                     free: false,
                     imageName: "hand.raised.slash.fill", color: Colors.redColor, whiteBlackList: false),
        FilterSource(name: "Block Irritating Element",
                     url: "https://filters.adtidy.org/ios/filters/14_optimized.txt",
                     description: "Filter blocks in-page pop-ups and third-party widgets on websites.",
                     free: false,
                     imageName: "flame.fill", color: Colors.yellowColor, whiteBlackList: false),
        FilterSource(name: "Block Russian Language Websites",
                     url: "https://filters.adtidy.org/ios/filters/1_optimized.txt",
                     description: "Filter blocks ads on Russian-language sites.",
                     free: false,
                     imageName: "flag.fill", color: Colors.greenBlueColor, whiteBlackList: false),
        FilterSource(name: "Block German Language Websites",
                     url: "https://filters.adtidy.org/ios/filters/6_optimized.txt",
                     description: "Filter blocks ads on German-language sites.",
                     free: false,
                     imageName: "flag.fill", color: Colors.purpleColor, whiteBlackList: false),
        FilterSource(name: "Block Spanish & Portuguese Language Websites",
                     url: "https://filters.adtidy.org/ios/filters/9_optimized.txt",
                     description: "Filter blocks ads on Spanish/Portuguese sites.",
                     free: false,
                     imageName: "flag.fill", color: Colors.greenColor, whiteBlackList: false),
        FilterSource(name: "Block French Language Website",
                     url: "https://filters.adtidy.org/ios/filters/16_optimized.txt",
                     description: "Filter blocks ads on French sites.",
                     free: false,
                     imageName: "flag.fill", color: Colors.orangeColor, whiteBlackList: false)
    ]
    struct Links {
        static let privacyPolicy = "https://www.superagentdefense.com/?page_id=7"
        static let termsOfUse = "https://www.superagentdefense.com/?page_id=13"
    }
    static let supportEmail = "support@superagentdefense.com"
}
