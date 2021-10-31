//
//  AttemptsRemaining.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import SwiftUI

struct AttemptsRemainingView: View {
	let attemptsRemaining: Int
	let unlockDate: Date?
	
	var body: some View {
		Group {
			if let unlockDate = unlockDate {
				HStack(spacing: 3) {
					Text("Try again in")
                    if #available(iOS 14.0, *) {
                        Text(unlockDate.addingTimeInterval(1), style: .relative)
                    } else {
                        // Fallback on earlier versions
                    }
				}
			} else {
				switch attemptsRemaining {
				case 0: Text("No Attempts Remaining")
				case 1: Text("1 Attempt Remaining")
				case _: Text("\(attemptsRemaining) Attempts Remaining")
				}
			}
		}
        .font(.custom(FontNames.exoSemiBold, size: 18))
		.padding(10)
		.background(Color.red.opacity(0.2))
		.clipShape(Capsule())
	}
}

struct AttemptsRemainingView_Previews: PreviewProvider {
	static var previews: some View {
		AttemptsRemainingView(attemptsRemaining: 4, unlockDate: nil)
			.padding()
			.previewLayout(.sizeThatFits)
		
		AttemptsRemainingView(attemptsRemaining: 1, unlockDate: nil)
			.padding()
			.previewLayout(.sizeThatFits)
		
		AttemptsRemainingView(attemptsRemaining: 0, unlockDate: nil)
			.padding()
			.previewLayout(.sizeThatFits)
		
		AttemptsRemainingView(attemptsRemaining: 4, unlockDate: Date().addingTimeInterval(100))
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
