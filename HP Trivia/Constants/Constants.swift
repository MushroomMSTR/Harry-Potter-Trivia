//
//  Constants.swift
//  HP Trivia
//
//  Created by NazarStf on 22.07.2023.
//

import Foundation
import SwiftUI

// MARK: - Constants
// A struct to hold constant values that are used throughout the app.
enum Constants {
	// The font used in the Harry Potter branding.
	static let hpFont = "PartyLetPlain"
	
	// A preview question for the app, fetched from a local JSON file.
	static let previewQustion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}

// MARK: - InfoBackgroundInfo View
// A view that displays a parchment image as the background.
struct InfoBackgroundInfo: View {
	var body: some View {
		Image("parchment")
			.resizable()
			.ignoresSafeArea()
			.background(.brown)
	}
}

// MARK: - Button Extensions
// Extensions that provide predefined styles for buttons.
extension Button {
	// A style for "Done" buttons.
	func doneButton() -> some View {
		self
			.font(.largeTitle)
			.padding()
			.buttonStyle(.borderedProminent)
			.tint(.brown)
			.foregroundColor(.white)
			.shadow(radius: 2)
	}
	
	// A style for "Play" buttons. The tint color depends on whether any books are active.
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

// MARK: - FileManager Extension
// An extension to provide a shortcut for accessing the app's documents directory.
extension FileManager {
	static var documentsDirectory: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		
		return paths[0]
	}
}
