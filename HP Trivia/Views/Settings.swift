//
//  Settings.swift
//  HP Trivia
//
//  Created by NazarStf on 23.07.2023.
//

import SwiftUI

enum BookStatus {
	case active
	case inactive
	case locked
}

struct Settings: View {
	@Environment(\.dismiss) private var dismiss
	@State private var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
	
	var body: some View {
		ZStack {
			InfoBackgroundInfo()
			
			VStack {
				Text("Which books would you like to see questions from?")
					.font(.title)
					.multilineTextAlignment(.center)
					.padding(.top)
				
				ScrollView {
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						ForEach(0..<7) { i in
							if books[i] == .active {
								ZStack(alignment: .bottomTrailing) {
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
									
									Image(systemName: "checkmark.circle.fill")
										.font(.largeTitle)
										.imageScale(.large)
										.foregroundColor(.green)
										.shadow(radius: 1)
										.padding(3)
								}
								.onTapGesture {
									books[i] = .inactive
								}
							} else if books[i] == .inactive {
								ZStack(alignment: .bottomTrailing) {
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
										.overlay(Rectangle().opacity(0.33))
									
									Image(systemName: "circle")
										.font(.largeTitle)
										.imageScale(.large)
										.foregroundColor(.green.opacity(0.5))
										.shadow(radius: 1)
										.padding(3)
								}
								
								.onTapGesture {
									books[i] = .active
								}
							} else {
								ZStack {
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
										.overlay(Rectangle().opacity(0.75))
									
									Image(systemName: "lock.fill")
										.font(.largeTitle)
										.imageScale(.large)
										.shadow(color: .white.opacity(0.75), radius: 3)
								}
							}
						}
					}
					.padding()
				}
				
				Button("Done") {
					dismiss()
				}
				.doneButton()
			}
		}
	}
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
