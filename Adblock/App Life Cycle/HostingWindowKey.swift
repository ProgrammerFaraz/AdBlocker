//
//  HostingWindowKey.swift
//  Adblock
//
//  Created by Faraz on 11/20/21.
//

import Foundation
import SwiftUI

struct HostingWindowKey: EnvironmentKey {

#if canImport(UIKit)
    typealias WrappedValue = UIWindow
#elseif canImport(AppKit)
    typealias WrappedValue = NSWindow
#else
    #error("Unsupported platform")
#endif

    typealias Value = () -> WrappedValue? // needed for weak link
    static let defaultValue: Self.Value = { nil }
}

extension EnvironmentValues {
    var hostingWindow: HostingWindowKey.Value {
        get {
            return self[HostingWindowKey.self]
        }
        set {
            self[HostingWindowKey.self] = newValue
        }
    }
}


final class AppData: ObservableObject {
    let window: UIWindow? // Will be nil in SwiftUI previewers

    init(window: UIWindow? = nil) {
        self.window = window
    }
}
