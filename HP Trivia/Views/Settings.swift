//
//  Settings.swift
//  HP Trivia
//
//  Created by NazarStf on 23.07.2023.
//

import SwiftUI

// MARK: - Settings View

// Define the Settings struct that conforms to the View protocol.
struct Settings: View {
	// Create an environment variable to dismiss the view.
	@Environment(\.dismiss) private var dismiss
	// Create an environment object for the Store.
	@EnvironmentObject private var store: Store
	
	// Define the body of the Settings view.
	var body: some View {
		// Wrap the elements in a ZStack to stack them on top of each other.
		ZStack {
			// Set the background of the view.
			InfoBackgroundInfo()
			
			// Use VStack to align elements vertically.
			VStack {
				// Display the instruction text.
				Text("Which books would you like to see questions from?")
					.font(.title)
					.multilineTextAlignment(.center)
					.padding(.top)
				
				// Wrap the grid in a ScrollView.
				ScrollView {
					// Create a grid for the book images.
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						// Loop through the books.
						ForEach(0..<7) { i in
							// If the book is active or purchased, display the active book image.
							if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIDs.contains("hp\(i+1)")) {
								ZStack(alignment: .bottomTrailing) {
									// Display the book image.
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
									
									// Display the checkmark icon.
									Image(systemName: "checkmark.circle.fill")
										.font(.largeTitle)
										.imageScale(.large)
										.foregroundColor(.green)
										.shadow(radius: 1)
										.padding(3)
								}
								.task {
									// Set the book to active and save the status.
									store.books[i] = .active
									store.saveStatus()
								}
								.onTapGesture {
									// Set the book to inactive and save the status when tapped.
									store.books[i] = .inactive
									store.saveStatus()
								}
							// If the book is inactive, display the inactive book image.
							} else if store.books[i] == .inactive {
								ZStack(alignment: .bottomTrailing) {
									// Display the book image with an overlay.
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
										.overlay(Rectangle().opacity(0.33))
									
									// Display the circle icon.
									Image(systemName: "circle")
										.font(.largeTitle)
										.imageScale(.large)
										.foregroundColor(.green.opacity(0.5))
										.shadow(radius: 1)
										.padding(3)
								}
								
								.onTapGesture {
									// Set the book to active and save the status when tapped.
									store.books[i] = .active
									store.saveStatus()
								}
							// If the book is locked, display the locked book image.
							} else {
								ZStack {
									// Display the book image with an overlay.
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
										.overlay(Rectangle().opacity(0.75))
									
									// Display the lock icon.
									Image(systemName: "lock.fill")
										.font(.largeTitle)
										.imageScale(.large)
										.shadow(color: .white.opacity(0.75), radius: 3)
								}
								.onTapGesture {
									// Purchase the book when tapped.
									let product = store.products[i-3]
									
									Task {
										await
										store
											.purchase(product)
									}
								}
							}
						}
					}
					.padding()  // Add padding to the grid.
				}
				
				// Display the Done button.
				Button("Done") {
					// Call the dismiss function when the button is tapped.
					dismiss()
				}
				.doneButton()  // Apply the doneButton style.
			}
			.foregroundColor(.black)  // Set the text color for all elements in the VStack.
		}
	}
}

// MARK: - Preview

// Define a PreviewProvider for the Settings view.
struct Settings_Previews: PreviewProvider {
	static var previews: some View {
		Settings()
			.environmentObject(Store())
	}
}
