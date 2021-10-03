//
//  StatusView.swift
//  Security Manager
//
//  Created by Faraz on 10/2/21.
//

import SwiftUI

struct StatusView: View {
    
    @State private var toggleOn = false
    
    var body: some View {
        
        VStack {
            if toggleOn {
                Image(uiImage: UIImage(named: "logo_gray")!)
                    .resizable()
                    .frame(width: 150, height: 180)
                Text("YOU ARE PROTECTED")
                    .font(.system(size: 25, weight: .bold, design: .default))
            }else {
                Image(uiImage: UIImage(named: "logo")!)
                    .resizable()
                    .frame(width: 150, height: 180)
                Text("YOU ARE NOT PROTECTED")
                    .font(.system(size: 25, weight: .bold, design: .default))
            }
            Spacer()
                .frame(height: 50)
            Toggle("", isOn: $toggleOn)
            .toggleStyle(SwitchToggleStyle(tint: .red))
            .labelsHidden()
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
