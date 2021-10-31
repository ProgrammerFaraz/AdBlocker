import Foundation
import Combine

class WebViewModel: ObservableObject{
    var webViewNavigationPublisher = PassthroughSubject<WebViewNavigation, Never>()
    var showWebTitle: String = "Google"
    var showLoader = PassthroughSubject<Bool, Never>()
    @Published var url: String = "https://google.com"
}

enum WebViewNavigation {
    case backward, forward, reload, load
}


