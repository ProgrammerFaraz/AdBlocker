//
//  ActivityIndicator.swift
//  Adblock
//
//  Created by Faraz on 11/19/21.
//

import Foundation
import SwiftUI
import ActivityIndicatorView

//struct ActivityIndicator {
//
//    @Binding var isAnimating: Bool
////    let style: UIActivityIndicatorView.Style
//
////    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
////        return UIActivityIndicatorView(style: style)
////    }
//
////    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
////        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
////    }
//}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
//        GeometryReader { geometry in
            ZStack() {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

//                VStack {
//                    Text("Loading...")
                ActivityIndicatorView(isVisible: $isShowing, type: .flickeringDots)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.red)

//                ActivityIndicator(isAnimating: .constant(true), style: .large)
//                }
//                .frame(width: geometry.size.width / 2,
//                       height: geometry.size.height / 5)
//                .background(Color.secondary.colorInvert())
//                .foregroundColor(Color.primary)
//                .cornerRadius(20)
//                .opacity(self.isShowing ? 1 : 0)

            }
//        }
    }

}
