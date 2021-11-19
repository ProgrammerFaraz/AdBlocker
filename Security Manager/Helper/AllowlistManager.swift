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

class AllowlistManager {

    /// Uses input array and adds to Content Blocker JSON Files.
    ///
    /// - Parameter domainList: An array of URL's to be added to the allowlist.
    func applyAllowlist(_ domainList: [String]) {
        // swiftlint:disable:previous function_body_length

        let allowlistArray: NSMutableArray = []
        for allowlistURLString in domainList {

            let myString = ["action": ["type": "ignore-previous-rules"], "trigger": ["url-filter": ".*", "if-top-url": ["\(allowlistURLString)"]]]
            allowlistArray.add(myString)

        }

        let sharedContainer = (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupIdentifier))
        // Setting paths
        let easylistPath = URL(string: "\(Constants.sharedFilterlist).json", relativeTo: sharedContainer)
        let easylistExceptionsPath = URL(string: "\(Constants.sharedFilterlistPlusExceptionRules).json", relativeTo: sharedContainer)
        let easylistOriginalPath = URL(string: "\(Constants.sharedFilterlistOriginal).json", relativeTo: sharedContainer)
        let easylistExceptionsOriginalPath = URL(string: "\(Constants.sharedFilterlistPlusExceptionRulesOriginal).json", relativeTo: sharedContainer)

        // Setting data
        let easylistData = try? Data(contentsOf: easylistOriginalPath!)
        let easylistExceptionsData = try? Data(contentsOf: easylistExceptionsOriginalPath!)

        // Converting to JSON
        guard let easylistJSON = nsdataToJSON(easylistData!) as? NSMutableArray else { return }
        guard let easylistExceptionsJSON = nsdataToJSON(easylistExceptionsData!) as? NSMutableArray else { return }

        // Adding from array
        easylistJSON.addObjects(from: allowlistArray as [AnyObject])
        easylistExceptionsJSON.addObjects(from: allowlistArray as [AnyObject])

        // Move old file

        do {
            try (easylistPath as NSURL?)?.setResourceValue("blocklistOld.JSON", forKey: URLResourceKey.nameKey)

        } catch _ as NSError {
        }

        do {
            try (easylistExceptionsPath as NSURL?)?.setResourceValue("blocklistAAOld.JSON", forKey: URLResourceKey.nameKey)

        } catch _ as NSError {
        }

        let blankData = Data()

        // creating a .json file in the Documents folder
        _ = (try? blankData.write(to: easylistPath!, options: [.atomic])) != nil
        _ = (try? blankData.write(to: easylistExceptionsPath!, options: [.atomic])) != nil

        // creating JSON out of the above array
        var jsonData: Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: easylistJSON, options: JSONSerialization.WritingOptions())
            _ = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch _ as NSError {
        }

        do {
            jsonData = try JSONSerialization.data(withJSONObject: easylistExceptionsJSON, options: JSONSerialization.WritingOptions())
            _ = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch _ as NSError {
        }

        // Write that JSON to the file created earlier
        do {
            let file = try FileHandle(forWritingTo: easylistPath!)
            file.write(jsonData)
        } catch _ as NSError {
        }

        // Write that JSON to the file created earlier
        do {
            let file = try FileHandle(forWritingTo: easylistExceptionsPath!)
            file.write(jsonData)
        } catch _ as NSError {
        }
    }

    private func nsdataToJSON(_ data: Data) -> AnyObject {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch _ {
            // Unable to serialize json
        }
        return 0 as AnyObject
    }
}
