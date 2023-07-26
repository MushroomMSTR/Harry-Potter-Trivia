//
//  ContentView.swift
//  HP Trivia
//
//  Created by NazarStf on 21.07.2023.
//

// Import the SwiftUI and AVKit frameworks.
// SwiftUI is used for designing the UI, and AVKit is used for playing audio.
import SwiftUI
import AVKit

// MARK: - ContentView

// Define a struct named 'ContentView' which conforms to the 'View' protocol.
struct ContentView: View {
	
	// Declare EnvironmentObject properties for the store and game.
	// These are observable objects that are shared across the whole app.
	@EnvironmentObject private var store: Store
	@EnvironmentObject private var game: Game

	// Declare State properties for the audio player, animations, and UI states.
	@State private var audioPlayer: AVAudioPlayer!
	@State private var scalePlayButton = false
	@State private var moveBackgroundImage = false
	@State private var isMuted = false
	@Environment(\.colorScheme) var colorScheme
	@State private var animateViewsIn = false
	@State private var showInstruction = false
	@State private var showSettings = false
	@State private var playGame = false

	// MARK: - Body

	// The body property contains the UI elements of the view.
	var body: some View {
		// Use GeometryReader to get the size of the view.
		GeometryReader { geo in
			// Use ZStack to layer views on top of each other.
			ZStack {
				// Background image.
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height)
					.padding(.top, 3)
					.offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1)
					.onAppear {
						// Animate the background image.
						withAnimation(.linear(duration: 60).repeatForever()) {
							moveBackgroundImage.toggle()
						}
					}

				// Main content of the view.
				VStack {
					// Title and audio button.
					ZStack {
						VStack {
							if animateViewsIn {
								HStack {
									Spacer()

									// Mute/unmute button.
									Button(action: {
										isMuted.toggle()
										if isMuted {
											audioPlayer.pause()
										} else {
											audioPlayer.play()
										}
									}) {
										Image(systemName: isMuted ? "play.slash.fill" : "play.fill")
											.font(.largeTitle)
											.padding()
											.foregroundColor(colorScheme == .dark ? .white : .black)
											.shadow(radius: 2)
									}
									.padding(25)
									.padding(.bottom, 70)
								}
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)

						// Game title.
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

					// Recent scores.
					VStack {
						if animateViewsIn {
							VStack {
								Text("Recent Scores")
									.font(.title2)

								Text("\(game.recentScores[0])")
								Text("\(game.recentScores[1])")
								Text("\(game.recentScores[2])")

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

					// Play, Info, and Settings buttons.
					HStack {
						Spacer()

						// Info button.
						VStack {
							if animateViewsIn {
								Button {
									showInstruction.toggle()
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

						// Play button.
						VStack {
							if animateViewsIn {
								Button {
									filterQuestions()
									game.startGame()
									playGame.toggle()
								} label: {
									Text("Play")
								}
								.playButton(store: store)
								.scaleEffect(scalePlayButton ? 1.2 : 1)
								.onAppear {
									withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
										scalePlayButton.toggle()
									}
								}
								.transition(.offset(y: geo.size.height/3))
								.fullScreenCover(isPresented: $playGame) {
									Gameplay()
										.environmentObject(game)
										.onAppear {
											audioPlayer.setVolume(0, fadeDuration: 2)
										}
										.onDisappear {
											audioPlayer.setVolume(1, fadeDuration: 3)
										}
								}
								.disabled(store.books.contains(.active) ? false : true)
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)

						Spacer()

						// Settings button.
						VStack {
							if animateViewsIn {
								Button {
									showSettings.toggle()
								} label: {
									Image(systemName: "gearshape.fill")
										.font(.largeTitle)
										.foregroundColor(.white)
										.shadow(radius: 5)
								}
								.transition(.offset(x: geo.size.width/4))
								.sheet(isPresented: $showSettings) {
									Settings()
										.environmentObject(store)
								}
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)

						Spacer()
					}
					.frame(width: geo.size.width)

					// No questions available message.
					VStack {
						if animateViewsIn {
							if store.books.contains(.active) == false {
								Text("No questions available. Go to settings. ⬆️")
									.multilineTextAlignment(.center)
									.transition(.opacity)
							}
						}
					}
					.animation(.easeInOut.delay(3), value: animateViewsIn)

					Spacer()
				}
			}
			.frame(width: geo.size.width, height: geo.size.height)
		}
		.ignoresSafeArea()
		.onAppear {
			animateViewsIn = true
			playAudio()
			audioPlayer.volume = 0.3
		}
	}

	// MARK: - Audio Player

	// Function to initialize and play audio.
	private func playAudio() {
		if let sound = Bundle.main.path(forResource: "Audio/magic-in-the-air", ofType: "mp3") {
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				audioPlayer.numberOfLoops = -1
				audioPlayer.play()
			} catch {
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
	}

	// MARK: - Filter Questions

	// Function to filter the available questions based on the books that are active.
	private func filterQuestions() {
		var books: [Int] = []
		
		for (index, status) in store.books.enumerated() {
			if status == .active {
				books.append(index+1)
			}
		}
		
		game.filterQuestions(to: books)
		game.newQuestion()
	}
}

// Define a preview for the ContentView.
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			ContentView()
				.environmentObject(Store())
				.environmentObject(Game())
		}
	}
}
