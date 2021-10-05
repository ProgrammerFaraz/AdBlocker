//
//  HowToUseView.swift
//  Security Manager
//
//  Created by Faraz on 10/5/21.
//

import SwiftUI

struct HowToUseView: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            PagerView(pageCount: 3, currentIndex: $currentPage) {
                Color.blue
                Color.red
                Color.green
            }
            VStack(alignment: .leading) {
                Text("Step \(currentPage + 1)")
                    .padding(.leading, 25)
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.red)
                containedIndex()
                    .padding(.leading, 25)
                Spacer()
                    .frame(height: 25)
            }
            Button(action: {
                nextTapped()
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                     )
            }
            Spacer()
                .frame(height: 50)
        }
    }
    
    func containedIndex() -> Text {
        switch currentPage {
        case 0:
            return Text("Go to Setting App")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 1:
            return Text("Go to Safari")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 2:
            return Text("Go to the Content ")
                .font(.system(size: 20, weight: .bold, design: .default))
        default: break
        }
        return Text("")
    }
    
    func nextTapped() {
        if currentPage == 2 {
            currentPage = 0
        }else {
            currentPage += 1
        }
    }
}


struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
