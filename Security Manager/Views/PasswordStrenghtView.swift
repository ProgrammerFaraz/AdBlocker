//
//  PasswordStrenghtView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/06/2021.
//

import SwiftUI

struct PasswordStrenghtView: View {
    
    let entropy:Double
    @State private var animate = false
    
    var body: some View {
        
        HStack(alignment: .center) {
            Text(entropyText(entropy: entropy))
                .foregroundColor(.white)
                .font(.custom(FontNames.exoMedium, size: 16))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(entropyColor(entropy: entropy).opacity(0.1))
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(entropyColor(entropy: entropy).opacity(0.3), lineWidth: 2)
        )
        .animation(animate ? .easeInOut(duration: 0.2) : nil)
        .transition(.identity)
        .onChange(of: entropy, perform: { value in
            animate = true
        })
    }
}

extension View {
    func entropyText(entropy: Double) -> String {
        
        switch entropy {
        case 128.0...200:
            return "Very strong"
        case 60.0...128:
            return "Strong"
        case 36.0...60:
            return "Reasonable"
        case 28.0...36:
            return "Weak"
        default:
            return "Very weak"
        }
    }
    
    func entropyColor(entropy: Double) -> Color {
        
        switch entropy {
        case 128.0...200:
            return Colors.blueColor
        case 60.0...128:
            return Colors.greenColor
        case 36.0...60:
            return Colors.yellowColor
        case 28.0...36:
            return Colors.orangeColor
        default:
            return Colors.redColor
        }
    }
}

struct PasswordStrenghtView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            PasswordStrenghtView(entropy: 200)
        }
    }
}
