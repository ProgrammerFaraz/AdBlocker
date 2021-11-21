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
    enum WorkState: String {
        case initial
        case done
        case working
        case errorOccurred
    }
    let request: URLRequest?
    @Binding var workState: WorkState
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInWebViewNotification), object: nil, userInfo: ["value": true])
        switch self.workState {
        case .initial:
            if request == nil {
                if let windowScene = UIApplication.shared.windows.first?.windowScene  {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInWebViewNotification), object: nil, userInfo: ["value": false])
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }else {
                uiView.load(request ?? URLRequest(url: URL(string: "")!))
            }
        case .errorOccurred:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInWebViewNotification), object: nil, userInfo: ["value": false])
        case .done:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInWebViewNotification), object: nil, userInfo: ["value": false])
        default:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.showLoaderInWebViewNotification), object: nil, userInfo: ["value": false])
            break
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.workState = .working
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.parent.workState = .errorOccurred
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.workState = .done
        }
        
        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}

struct WebViewPage: View {
//    @State var showRateUs = false
    var request: URLRequest?
    @State var showActivityIndicator = false
    let pub = NotificationCenter.default
        .publisher(for: NSNotification.Name(Constants.showLoaderInWebViewNotification))
    @State var workState = WebView.WorkState.initial

    var body: some View {
        LoadingView(isShowing: $showActivityIndicator) {
            WebView(request: request, workState: $workState)
        }
        .onReceive(pub) { output in
            print("🔥 show loader: \(output.userInfo?["value"] as! Bool)🔥")
            self.showActivityIndicator = output.userInfo?["value"] as! Bool
        }
    }
}
//struct WebView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebView()
//    }
//}

