//
//  LockView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct LockView: View {
	enum CodeState {
		case undefined
		case correct
		case incorrect
	}

	@EnvironmentObject private var passcodeManager: PasscodeManager
	@ObservedObject var lockoutManager = LockoutManager()
	@Binding var isLocked: Bool
	@State var code = ""
	@State var attempts = 0
	@State var codeState: CodeState = .undefined
	@State var incorrectAnimation = false

	var maxDigits: Int { passcodeManager.passcode.count }
	var codeIsFullyEntered: Bool { code.count == maxDigits }
	var codeIsCorrect: Bool { code == passcodeManager.passcode }
	var remainingAttempts: Int {
		if lockoutManager.isLockedOut { return 0 }
		return 5 - attempts
	}

	var body: some View {
		ZStack {
            Colors.bgColor.ignoresSafeArea()
			VStack(spacing: 25) {
				AttemptsRemainingView(attemptsRemaining: remainingAttempts, unlockDate: lockoutManager.unlockDate)
					.opacity(attempts > 0 || lockoutManager.isLockedOut ? 1.0 : 0.0)
				InputDisplay(input: $code, codeLength: passcodeManager.passcodeLength, textColor: textColor, displayColor: displayColor)
					.shake(incorrectAnimation, distance: 10, count: 4)
				KeypadView(input: input, delete: delete) {
                    Button("", action: {})
				}
			}
			.frame(maxWidth: 280)
			.onChange(of: lockoutManager.isLockedOut) { value in
				guard !value else { return }
				attempts = 0
				code = ""
				codeState = .undefined
			}
		}
        .font(.custom(FontNames.exoSemiBold, size: 22))
	}

	var textColor: Color {
		switch codeState {
		case .correct: return .green
		case .incorrect: return .red
		case _ where remainingAttempts == 0: return .red
		case _: return .primary
		}
	}

	var displayColor: Color? {
		switch codeState {
		case .correct: return .green
		case .incorrect: return .red
		case _ where remainingAttempts == 0: return .red
		case _: return nil
		}
	}

	func input(_ string: String) {
		guard !codeIsFullyEntered else { return }
		code.append(string)

		if codeIsFullyEntered {
			withAnimation {
				if codeIsCorrect {
					allowEntry()
				} else {
					rejectEntry()
				}
			}
			return
		}

		codeState = .undefined
	}

	func delete() {
		guard !code.isEmpty else {
			return
		}
		code.removeLast()
		codeState = .undefined
	}

	func allowEntry() {
		codeState = .correct
		code = Array(repeating: "●", count: passcodeManager.passcodeLength).joined()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			withAnimation {
				isLocked = false
			}
		}
	}

	func rejectEntry() {
		attempts += 1
		codeState = .incorrect
		incorrectAnimation.toggle()
		if attempts == 5 {
			lockoutManager.lockout()
		} else {
			code = ""
		}
	}
}

struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		LockView(isLocked: .constant(true))
			.environmentObject(PasscodeManager())
            .preferredColorScheme(.dark)
	}
}
