////
////  SetPasscodeView.swift
////  PrivateVault
////
////  Created by Emilio Peláez on 21/2/21.
////
//
//import SwiftUI
//import SwiftUIX
//
//struct SetPasscodeView: View {
//	enum CodeState {
//		case undefined
//		case match
//		case mismatch
//	}
//	
//	@State var code: String = ""
//	@State var enteredCode: String = ""
//	@State var codeLengthIndex: Int = 0
//	@State var codeLength: Int = 4
//	@State var codeState: CodeState = .undefined
//	@State var waitingForAnimation = false
//	@State var showMismatchAlert = false
//	
//	let newCode: (String, Int) -> Void
//	
//	var body: some View {
//		ZStack {
//            Colors.bgColor.ignoresSafeArea()
//			VStack(spacing: 25) {
//				VStack(spacing: 10) {
//					if enteredCode.isEmpty {
//						VStack {
//							Text("Create your Passcode")
//                                .font(.custom(FontNames.exoSemiBold, size: 25))
//						}
//                        .transition(.opacity) // FIXME: - fix this to original state like below line
////						.transition(.opacity.combined(with: .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))))
//					} else {
//						Text("Confirm your Passcode")
//                            .font(.custom(FontNames.exoSemiBold, size: 25))
//                            .transition(.opacity) //TODO:- Find a solution for this line. Date: 19-9-2021
////							.transition(.opacity.combined(with: .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))))
//					}
//					Picker(selection: $codeLengthIndex, label: Text("")) {
//						Text("4 Digits").tag(0)
//						Text("6 Digits").tag(1)
//					}
//					.pickerStyle(SegmentedPickerStyle())
//					.opacity(enteredCode.isEmpty ? 1 : 0)
//				}
//				InputDisplay(input: $code, codeLength: codeLength, textColor: textColor, displayColor: displayColor)
//				KeypadView(input: input, delete: delete) { Spacer() }
//					.disabled(waitingForAnimation)
//			}
//			.frame(maxWidth: 280)
//		}
//		.alert(isPresented: $showMismatchAlert) {
//			Alert(title: Text("Try Again!"),
//						message: Text("Make sure your passcodes match."),
//						dismissButton: .default(Text("Ok!")))
//		}
//		.onChange(of: codeLengthIndex) { index in
//			withAnimation {
//				codeLength = [4, 6][index]
//				code = String(code.prefix(max(0, codeLength - 1)))
//			}
//		}
//	}
//	
//	var textColor: Color {
//		switch codeState {
//		case .match: return .green
//		case .mismatch: return .red
//		case _: return .primary
//		}
//	}
//
//	var displayColor: Color? {
//		switch codeState {
//		case .match: return .green
//		case .mismatch: return .red
//		case _: return nil
//		}
//	}
//	
//	func input(_ string: String) {
//		guard code.count < codeLength else { return }
//		code.append(string)
//		guard code.count == codeLength else {
//			withAnimation {
//				codeState = .undefined
//			}
//			return
//		}
//		if enteredCode.isEmpty {
//			waitingForAnimation = true
//			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//				withAnimation {
//					waitingForAnimation = false
//					enteredCode = code
//					code = ""
//				}
//			}
//		} else if enteredCode == code {
//			withAnimation {
//				codeState = .match
//			}
//			waitingForAnimation = true
//			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//				waitingForAnimation = false
//				newCode(code, codeLength)
//			}
//		} else {
//			showMismatchAlert = true
//			withAnimation {
//				enteredCode = ""
//				code = ""
//				codeState = .mismatch
//			}
//		}
//	}
//	
//	func delete() {
//		guard !code.isEmpty else { return }
//		code.removeLast()
//		withAnimation {
//			codeState = .undefined
//		}
//	}
//}
//
//struct SetPasscodeView_Previews: PreviewProvider {
//	static var previews: some View {
//		SetPasscodeView(code: "01") { _, _ in }
//            .preferredColorScheme(.dark)
//		SetPasscodeView(code: "012", codeLength: 6) { _, _ in }
//	}
//}
