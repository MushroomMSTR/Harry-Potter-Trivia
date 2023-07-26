//
//  Instructions.swift
//  HP Trivia
//
//  Created by NazarStf on 22.07.2023.
//

import SwiftUI

// MARK: - Instructions View

// Define the Instructions struct that conforms to the View protocol.
struct Instructions: View {
	// Create an environment variable to dismiss the view.
	@Environment(\.dismiss) private var dismiss
	
	// Define the body of the Instructions view.
	var body: some View {
		// Wrap the elements in a ZStack to stack them on top of each other.
		ZStack {
			// Set the background of the view.
			InfoBackgroundInfo()
			
			// Use VStack to align elements vertically.
			VStack {
				// Display the app icon image.
				Image("appiconwithradius")
					.resizable()
					.scaledToFit()
					.frame(width: 150)
					.padding(.top)
				
				// Wrap the text elements in a ScrollView.
				ScrollView {
					// Display the title.
					Text("How to play")
						.font(.largeTitle)
						.padding()
					
					// Use VStack with leading alignment for the instructions text.
					VStack(alignment: .leading) {
						// Each Text view contains a part of the instructions.
						Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points! 😱")
							.padding([.horizontal, .bottom])
						
						Text("Each question is worth 5 points, but if you guess a wrong aswer, you lose 1 point.")
							.padding([.horizontal, .bottom])
						
						Text("If you are struggling with a question , there is an option to reveal a hint or reveal or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
							.padding([.horizontal, .bottom])
						
						Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
							.padding(.horizontal)
					}
					.font(.title3)  // Set the font for all Text views in the VStack.
					
					// Display the "Good Luck" message.
					Text("Good Luck 😉")
						.font(.title)
				}
				.foregroundColor(.black)  // Set the text color for all elements in the ScrollView.
				
				// Display the Done button.
				Button("Done") {
					// Call the dismiss function when the button is tapped.
					dismiss()
				}
				.doneButton()  // Apply the doneButton style.
			}
		}
	}
}

// MARK: - Preview

// Define a PreviewProvider for the Instructions view.
struct Instructions_Previews: PreviewProvider {
	static var previews: some View {
		Instructions()
	}
}
