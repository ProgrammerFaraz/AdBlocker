//
//  WebView.swift
//  Adblock
//
//  Created by Faraz on 11/20/21.
//

import SwiftUI
import WebKit
import StoreKit

struct WebView: UIViewRepresentable {

    let request: URLRequest?

    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if request == nil {
            if let windowScene = UIApplication.shared.windows.first?.windowScene  {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }else {
            uiView.load(request ?? URLRequest(url: URL(string: "")!))
        }
    }
}

struct WebViewPage: View {
//    @State var showRateUs = false
    var request: URLRequest?

    var body: some View {
        WebView(request: request)
    }
}
//struct WebView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebView()
//    }
//}
