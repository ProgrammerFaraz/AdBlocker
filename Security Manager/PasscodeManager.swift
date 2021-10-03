//
//  PasscodeManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 11/3/21.
//

import KeychainSwift
import SwiftUI

class PasscodeManager: ObservableObject {
	
	private let keychain = KeychainSwift()
	
	@Published
	var passcodeSet: Bool = false
	
	private let passcodeKey = "passcode"
	private let passcodeLengthKey = "passcodeLength"
	init() {
        self.passcode = keychain.get(passcodeKey) ?? ""
        self.passcodeLength = Int(keychain.get(passcodeLengthKey) ?? "6") ?? 6
		updatePasscodeSet()
	}
	
	var passcode: String {
		didSet {
            keychain.set(passcode, forKey: passcodeKey)
			updatePasscodeSet()
		}
	}
	
	var passcodeLength: Int {
		didSet {
            keychain.set(String(passcodeLength), forKey: passcodeLengthKey)
			updatePasscodeSet()
		}
	}
	
	private func updatePasscodeSet() {
		passcodeSet = passcode.count == passcodeLength
	}
	
}
