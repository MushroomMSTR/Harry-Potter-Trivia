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
	
	static let previewQustion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
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
	
	@MainActor func playButton(store: Store) -> some View {
		self
			.font(.largeTitle)
			.foregroundColor(.white)
			.padding(.vertical, 7)
			.padding(.horizontal, 50)
			.buttonStyle(.borderedProminent)
			.tint(store.books.contains(.active) ? .brown : .white)
			.shadow(radius: 5)
	}
}

extension FileManager {
	static var documentsDirectory: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		
		return paths[0]
	}
}
