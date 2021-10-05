//
//  TabBarView.swift
//  Security Manager
//
//  Created by Faraz on 10/1/21.
//

import SwiftUI

struct TabBarView: View {
    
    init() {
//        UITabBar.appearance().barTintColor = .systemBackground
    }
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            StatusView()
                .tabItem {
                    if selection == 0 {
                        Image(uiImage: UIImage(named: "status_selected")!)
                    }else {
                        Image(uiImage: UIImage(named: "status_unselected")!)
                    }
                    Text("Status")
                        .font(.system(size: 15))
                }.tag(0)
            HowToUseView()
                .tabItem {
                    if selection == 1 {
                        Image(uiImage: UIImage(named: "howtouse_selected")!)
                    }else {
                        Image(uiImage: UIImage(named: "howtouse_unselected")!)
                    }
                    Text("How to use")
                        .font(.system(size: 15))
                }.tag(1)
            
            SettingView()
                .tabItem {
                    if selection == 2 {
                        Image(uiImage: UIImage(named: "setting_selected")!)
                    }else {
                        Image(uiImage: UIImage(named: "setting_unselected")!)
                    }
                    Text("Setting")
                        .font(.system(size: 15))
                }.tag(2)
        }.accentColor(.white)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
