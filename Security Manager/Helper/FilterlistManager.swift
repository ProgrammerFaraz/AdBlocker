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

class FilterlistManager {

    /// Copies filter lists from Main Bundle to Shared Container
    /// To be used when app is first run, or to update the filter lists during app update.
    class func copyFilterListsToSharedContainer() {
        // This saves 2 copies of the blocklist. An original, and one that can be mutated as per the allowlist.
        let easylistFilePath = Bundle.main.url(forResource: Constants.easylist, withExtension: "json")
        let easylistExceptionsFilePath = Bundle.main.url(forResource: Constants.easylistExceptionRules, withExtension: "json")
        let easylistTestPath = Bundle.main.url(forResource: Constants.easylistTestRules, withExtension: "json")
        let easylistData = try? Data(contentsOf: easylistFilePath!)
        let easylistExceptionsData = try? Data(contentsOf: easylistExceptionsFilePath!)
        let easylistTestData = try? Data(contentsOf: easylistTestPath!)

        // Create a path to the shared container for filterlists to be copied to
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupIdentifier)
        let sharedFilterlistPath = URL(string: "\(Constants.sharedFilterlist).json", relativeTo: sharedContainer)
        let sharedFilterlistOriginalPath = URL(string: "\(Constants.sharedFilterlistOriginal).json", relativeTo: sharedContainer)
        let sharedFilterlistExceptionsPath = URL(string: "\(Constants.sharedFilterlistPlusExceptionRules).json", relativeTo: sharedContainer)
        let sharedFilterlistExceptionsOriginalPath = URL(
            string: "\(Constants.sharedFilterlistPlusExceptionRulesOriginal).json",
            relativeTo: sharedContainer)
        let sharedFilterlistTestPath = URL(string: "\(Constants.sharedFilterlistTest).json", relativeTo: sharedContainer)

        guard (try? easylistData?.write(to: sharedFilterlistPath!, options: [.atomic])) != nil else {
            return
        }
        guard (try? easylistData?.write(to: sharedFilterlistOriginalPath!, options: [.atomic])) != nil else {
            return
        }
        guard (try? easylistExceptionsData?.write(to: sharedFilterlistExceptionsPath!, options: [.atomic])) != nil else {
            return
        }
        guard (try? easylistExceptionsData?.write(to: sharedFilterlistExceptionsOriginalPath!, options: [.atomic])) != nil else {
            return
        }
        guard (try? easylistTestData?.write(to: sharedFilterlistTestPath!, options: [.atomic])) != nil else {
            return
        }
    }
}
