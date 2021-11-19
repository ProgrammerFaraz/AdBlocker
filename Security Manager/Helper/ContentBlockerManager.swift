/*
 * This file is part of Adblock Plus <https://adblockplus.org/>,
 * Copyright (C) 2006-present eyeo GmbH
 *
 * Adblock Plus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Adblock Plus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Adblock Plus.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation
import SafariServices

protocol ContentBlockerManagerDelegate: AnyObject {
    func contentBlockerStateDidFail(error: Error)
    func contentBlockerUpdateDidSucceed()
    func contentBlockerUpdateDidFail(error: Error)
}

class ContentBlockerManager: NSObject {

    private static var sharedContentBlockerManager: ContentBlockerManager = {
        let contentBlockerManager = ContentBlockerManager()
        return contentBlockerManager
    }()

    // MARK: Properties
    weak var delegate: ContentBlockerManagerDelegate?

    private override init() {}

    func getContentBlockerState() -> Bool {
        var contentBlockerState: Bool?
        let semaphore = DispatchSemaphore(value: 0)
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: Constants.contentBlockerIdentifier) { state, stateError in
            guard stateError == nil else {
            self.delegate?.contentBlockerStateDidFail(error: stateError!)
            return
            }
            contentBlockerState = state?.isEnabled
            semaphore.signal()
        }
        semaphore.wait()
        return contentBlockerState ?? false
    }

    /// Reloads content blocker extension.
    func reloadContentBlocker() {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: Constants.contentBlockerIdentifier, completionHandler: { updateError in
            guard updateError == nil else {
                self.delegate?.contentBlockerUpdateDidFail(error: updateError!)
                return
            }
            self.delegate?.contentBlockerUpdateDidSucceed()
        })
    }

    // MARK: - Accessors
    class func shared() -> ContentBlockerManager {
        return sharedContentBlockerManager
    }
}
