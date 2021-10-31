import Foundation
import UIKit
import SwiftUI
import Combine
import WebKit

protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
    func receivedStringValueFromWebView(value: String)
}

struct WebView: UIViewRepresentable, WebViewHandlerDelegate {   
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        print("JSON value received from web is: \(value)")
    }
    
    func receivedStringValueFromWebView(value: String) {
        print("String value received from web is: \(value)")
    }
    
    @ObservedObject var viewModel: WebViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: CGRect.zero)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = true
        webView.load(URLRequest(url: URL(string: viewModel.url)!))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: WebView
        var valueSubscriber: AnyCancellable? = nil
        var webViewNavigationSubscriber: AnyCancellable? = nil
        var delegate: WebViewHandlerDelegate?
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
        }
        
        deinit {
            valueSubscriber?.cancel()
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Get the title of loaded webcontent
            webView.evaluateJavaScript("document.title") { (response, error) in
                if let error = error {
                    print("Error getting title")
                    print(error.localizedDescription)
                }
                
                guard let title = response as? String else {
                    return
                }
                self.parent.viewModel.showWebTitle = title
                self.parent.viewModel.url = webView.url!.absoluteString
        }
            
            // Page loaded so no need to show loader anymore
            self.parent.viewModel.showLoader.send(false)
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            // Hides loader
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Hides loader
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.viewModel.url = webView.url!.absoluteString
            // Shows loader
            parent.viewModel.showLoader.send(true)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Shows loader
            parent.viewModel.showLoader.send(true)
            self.webViewNavigationSubscriber = self.parent.viewModel.webViewNavigationPublisher.receive(on: RunLoop.main).sink(receiveValue: { navigation in
                switch navigation {
                case .backward:
                    if webView.canGoBack {
                        webView.goBack()
                    }
                case .forward:
                    if webView.canGoForward {
                        webView.goForward()
                    }
                case .reload:
                    webView.reload()
                case .load:
                    var url: String = self.parent.$viewModel.url.wrappedValue.lowercased()

                    if !url.isEmpty {
                        if url.hasPrefix("www.") {
                            url = "https://" + url
                        }
                        if !(url.hasPrefix("https://") || url.hasPrefix("http://")) {
                            let words = url.replacingOccurrences(of: " ", with: "%20")
                            url = "https://www.google.com/search?q=" + words
                        }
                        webView.load(URLRequest(url: URL(string: url)!))
                    }
                }
            })
        }
    }
}

// MARK: - Extensions
extension WebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iOSNative" {
            if let body = message.body as? [String: Any?] {
                delegate?.receivedJsonValueFromWebView(value: body)
            } else if let body = message.body as? String {
                delegate?.receivedStringValueFromWebView(value: body)
            }
        }
    }
}

