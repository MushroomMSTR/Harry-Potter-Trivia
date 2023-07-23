//
//  Constants.swift
//  HP Trivia
//
//  Created by NazarStf on 22.07.2023.
//

import Foundation
import SwiftUI

enum Constants {
	static let hpFont = "PartyLetPlain"
}

struct InfoBackgroundInfo: View {
	var body: some View {
		Image("parchment")
			.resizable()
			.ignoresSafeArea()
			.background(.brown)
	}
}

extension Button {
	func doneButton() -> some View {
		self
			.font(.largeTitle)
			.padding()
			.buttonStyle(.borderedProminent)
			.tint(.brown)
			.foregroundColor(.white)
			.shadow(radius: 2)
	}
	
	func playButton() -> some View {
		self
			.font(.largeTitle)
			.foregroundColor(.white)
			.padding(.vertical, 7)
			.padding(.horizontal, 50)
			.buttonStyle(.borderedProminent)
			.tint(.brown)
			.shadow(radius: 5)
	}
}
