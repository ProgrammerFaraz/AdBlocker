//
//  SettingView.swift
//  Security Manager
//
//  Created by Faraz on 10/2/21.
//

import SwiftUI

enum SectionHeader: String, CaseIterable {
    case advanced = "Advanced"
    case resourcers = "Resourcers"
    case filters = "Filters"
    case accountSettings = "Account Settings"
}
// A struct to store exactly one setting's data.
struct SettingData: Identifiable {
    var id = UUID()
    let title: String
    let toggleOn: Bool?
    let image: Image?
    let sectionHeader : SectionHeader
}

// A view that shows the data for one setting.
struct SettingRow: View {
    
    @State private var isToggleOn = false
    var setting: SettingData
    
    var body: some View {
        
        HStack {
            setting.image
            Text("\(setting.title)")
            Spacer()
            Toggle("", isOn: $isToggleOn)
                .labelsHidden()
        }
        .lineSpacing(0)
    }
}

struct ExtrasRow: View {
    
    @State private var isToggleOn = false
    var setting: SettingData

    var body: some View {
        
        HStack {
//            Spacer(minLength: 20)
            Text("\(setting.title)")
            Spacer()
            Image(uiImage: UIImage(named: "white_arrow")!)
        }
        .lineSpacing(0)
    }
}

// Create three setting, then show them in a list.
struct SettingView: View {
    var settings = [
        SettingData(title: "Block ads", toggleOn: false, image: Image(uiImage: UIImage(named: "block_annoyances")!), sectionHeader: .advanced),
        SettingData(title: "Block Tracking", toggleOn: false, image: Image(uiImage: UIImage(named: "block_annoyances")!), sectionHeader: .advanced),
        SettingData(title: "Block Adult Sites", toggleOn: false, image: Image(uiImage: UIImage(named: "18+")!), sectionHeader: .advanced),
        SettingData(title: "Block Social Buttons", toggleOn: false, image: Image(uiImage: UIImage(named: "block_social")!), sectionHeader: .advanced),
        SettingData(title: "Block Annoyances", toggleOn: false, image: Image(uiImage: UIImage(named: "block_annoyances")!), sectionHeader: .resourcers),
        SettingData(title: "Block ads", toggleOn: false, image: Image(uiImage: UIImage(named: "block_annoyances")!), sectionHeader: .advanced),
        SettingData(title: "Block Comments", toggleOn: false, image: Image(uiImage: UIImage(named: "block_comment")!), sectionHeader: .advanced),
        SettingData(title: "Block Images", toggleOn: false, image: Image(uiImage: UIImage(named: "block_images")!), sectionHeader: .advanced),
        SettingData(title: "Block Custom Fonts", toggleOn: false, image: Image(uiImage: UIImage(named: "block_fonts")!), sectionHeader: .advanced),
        SettingData(title: "Block Scripts", toggleOn: false, image: Image(uiImage: UIImage(named: "block_scripts")!), sectionHeader: .advanced),
        SettingData(title: "Block Style Sheets", toggleOn: false, image: Image(uiImage: UIImage(named: "block_stylesheets")!), sectionHeader: .advanced),
        SettingData(title: "White List", toggleOn: false, image: Image(uiImage: UIImage(named: "whitelist")!), sectionHeader: .advanced),
        SettingData(title: "Black List", toggleOn: false, image: Image(uiImage: UIImage(named: "blacklist")!), sectionHeader: .filters),
        SettingData(title: "Privacy Policy", toggleOn: false, image: nil, sectionHeader: .accountSettings),
        SettingData(title: "Terms of Use", toggleOn: false, image: nil, sectionHeader: .accountSettings),
        SettingData(title: "Rate Us", toggleOn: false, image: nil, sectionHeader: .accountSettings)
    ]
    
    var body: some View {
        
        VStack {
            Text("Ad Blocker")
                .font(.system(size: 25, weight: .bold, design: .default))
                .frame(max: nil, alignment: .center)
                .background(.clear)
            List {
                ForEach(SectionHeader.allCases, id: \.rawValue) { sectionHeader in
                    Section(header: Text(sectionHeader.rawValue)) {
                        ForEach(settings.filter { $0.sectionHeader == sectionHeader }) { setting in
                            if setting.image == nil {
                                ExtrasRow(setting: setting)
                                    .listRowInsets(EdgeInsets())
                            }else {
                                SettingRow(setting: setting)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                }
            }.listStyle(GroupedListStyle())
        }
    }
}
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
