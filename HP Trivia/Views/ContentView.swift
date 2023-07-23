//
//  ContentView.swift
//  HP Trivia
//
//  Created by NazarStf on 21.07.2023.
//

import SwiftUI
import AVKit

// MARK: - ContentView
struct ContentView: View {
	// Create State variables for the audio player, button animation, and background image animation.
	@State private var audioPlayer: AVAudioPlayer!
	@State private var scalePlayButton = false
	@State private var moveBackgroundImage = false
	@State private var isMuted = false // State to track if the audio is muted.
	@Environment(\.colorScheme) var colorScheme // determine the current color scheme.
	@State private var animateViewsIn = false
	@State private var showInstruction = false

	var body: some View {
		// Use GeometryReader to adapt the layout to the available space.
		GeometryReader { geo in
			// Main container for all elements.
			ZStack {
				// Background image that moves horizontally.
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height)
					.padding(.top, 3)
					.offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1)
					.onAppear {
						withAnimation(.linear(duration: 60).repeatForever()) {
							moveBackgroundImage.toggle()
						}
					}
				
				// Main content container.
				VStack {
					// Game title and bolt icon.
					ZStack {
						VStack {
							if animateViewsIn {
								HStack {
									Spacer()
									
									// Here we insert the mute/unmute button.
									Button(action: {
										// Toggle the isMuted state.
										isMuted.toggle()
										// If the audio is to be muted, pause the audio player. Otherwise, play the audio.
										if isMuted {
											audioPlayer.pause()
										} else {
											audioPlayer.play()
										}
									}) {
										// Show the "play.slash" icon when the audio is muted and the "play" icon when it's not muted.
										Image(systemName: isMuted ? "play.slash.fill" : "play.fill")
											.font(.largeTitle)
											.padding()
											.foregroundColor(colorScheme == .dark ? .white : .black) // Set color based on color scheme.
											.shadow(radius: 2)
									}
									.padding(25)
									.padding(.bottom, 70)
								}
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
						
						VStack {
							if animateViewsIn {
								VStack {
									Image(systemName: "bolt.fill")
										.font(.largeTitle)
										.imageScale(.large)
									
									Text("HP")
										.font(.custom(Constants.hpFont, size: 70))
										.padding(.bottom, -50)
									
									Text("Trivia")
										.font(.custom(Constants.hpFont, size: 60))
								}
								.padding(.top, 70)
								.transition(.move(edge: .top))
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
					}
					.frame(width: geo.size.width)
					
					Spacer()
					
					// Section for recent scores.
					VStack {
						if animateViewsIn {
							VStack {
								Text("Recent Scores")
									.font(.title2)
								
								Text("33")
								Text("27")
								Text("15")
								
							}
							.font(.title3)
							.padding(.horizontal)
							.foregroundColor(.white)
							.background(.black.opacity(0.7))
							.cornerRadius(15)
							.transition(.opacity)
						}
					}
					.animation(.linear(duration: 1).delay(4), value: animateViewsIn)
					
					Spacer()
					
					// Section for buttons (Play, Info, Settings).
					HStack {
						Spacer()
						
						VStack {
							if animateViewsIn {
								// Info button.
								Button {
									showInstruction.toggle() // Show instructions screen.
								} label: {
									Image(systemName: "info.circle.fill")
										.font(.largeTitle)
										.foregroundColor(.white)
										.shadow(radius: 5)
								}
								.transition(.offset(x: -geo.size.width/4))
								.sheet(isPresented: $showInstruction) {
									Instructions()
								}
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
						
						Spacer()
						
						VStack {
							if animateViewsIn {
								// Play button.
								Button {
									// Start new game.
								} label: {
									Text("Play")
								}
								.playButton()
								.scaleEffect(scalePlayButton ? 1.2 : 1)
								.onAppear {
									withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
										scalePlayButton.toggle()
									}
								}
								.transition(.offset(y: geo.size.height/3))
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
						
						Spacer()
						
						VStack {
							if animateViewsIn {
								// Settings button.
								Button {
									// Show settings screen.
								} label: {
									Image(systemName: "gearshape.fill")
										.font(.largeTitle)
										.foregroundColor(.white)
										.shadow(radius: 5)
								}
								.transition(.offset(x: geo.size.width/4))
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
						
						Spacer()
					}
					.frame(width: geo.size.width)
					
					Spacer()
				}
			}
			.frame(width: geo.size.width, height: geo.size.height)
		}
		.ignoresSafeArea()
		.onAppear {
			animateViewsIn = true // When you launch the app, the logo animation is played
			// Call function to start playing audio.
			//playAudio()
		}
	}
	
	// Function to initialize and play audio.
	private func playAudio() {
		if let sound = Bundle.main.path(forResource: "Audio/magic-in-the-air", ofType: "mp3") {
			do {
				// Try to initialize the audio player
				audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				// Set the number of loops and play the audio
				audioPlayer.numberOfLoops = -1
				audioPlayer.play()
			} catch {
				// This block will execute if any error occurs
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		VStack {
			ContentView()
		}
    }
}
