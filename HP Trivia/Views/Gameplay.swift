//
//  Gameplay.swift
//  HP Trivia
//
//  Created by NazarStf on 23.07.2023.
//

import SwiftUI

struct Gameplay: View {
	
	@State private var animateViewsIn = false
	@State private var tappedCorrectAnswer = false
	@State private var hintWiggle = false
	@State private var scaleNextButton = false
	@State private var movePointToScore = false
	
    var body: some View {
		GeometryReader { geo in
			ZStack {
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
					.overlay(Rectangle().foregroundColor(.black.opacity(0.8)))
				
				VStack {
					// MARK: Controls
					HStack {
						Button("End Game") {
							// TODO: End game
						}
						.buttonStyle(.borderedProminent)
						.tint(.red.opacity(0.5))
						
						Spacer()
						
						Text("Score: 33")
					}
					.padding()
					.padding(.vertical, 30)
					
					// MARK: Question
					VStack {
						if animateViewsIn {
							Text("Who is Harry Potter?")
								.font(.custom(Constants.hpFont, size: 50))
								.multilineTextAlignment(.center)
								.padding()
								.transition(.scale)
						}
					}
					.animation(.easeOut(duration: 2), value: animateViewsIn)
					
					Spacer()
					
					// MARK: Hints
					HStack {
						VStack {
							if animateViewsIn {
								Image(systemName: "questionmark.app.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 100)
									.foregroundColor(.cyan)
									.rotationEffect(.degrees(hintWiggle ? -13 : -17))
									.padding()
									.padding(.leading, 20)
									.transition(.offset(x: -geo.size.width/2))
									.onAppear() {
										withAnimation(
											.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
												hintWiggle = true
											}
									}
							}
						}
						.animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
						
						Spacer()
						
						VStack {
							if animateViewsIn {
								Image(systemName: "book.closed")
									.resizable()
									.scaledToFit()
									.frame(width: 50)
									.foregroundColor(.black)
									.frame(width: 100, height: 100)
									.background(.cyan)
									.cornerRadius(20)
									.rotationEffect(.degrees(hintWiggle ?  13 : 17))
									.padding()
									.padding(.trailing, 20)
									.transition(.offset(x: geo.size.width/2))
									.onAppear() {
										withAnimation(
											.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
												hintWiggle = true
											}
									}
							}
						}
						.animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
					}
					.padding(.bottom)
					
					// MARK: Answers
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						ForEach(1..<5) { i in
							VStack {
								if animateViewsIn {
									Text(i == 3 ? "The boy who basically leved and got sent to his relatives house where he was treated quite badly if I'm being honest but yeah." : "Aswer \(i)")
										.minimumScaleFactor(0.5)
										.multilineTextAlignment(.center)
										.padding(10)
										.frame(width: geo.size.width/2.15, height: 80)
										.background(.green.opacity(0.5))
										.cornerRadius(25)
										.transition(.scale)
								}
							}
							.animation(.easeOut(duration: 1).delay(1.5), value: animateViewsIn)
						}
					}
					
					Spacer()
					
				}
				.frame(width: geo.size.width, height: geo.size.height)
				.foregroundColor(.white)
				
				// MARK: Selebration
				VStack {
					
					Spacer()
					
					VStack {
						if tappedCorrectAnswer {
							Text("5")
								.font(.largeTitle)
								.padding(.top, 50)
								.transition(.offset(y: -geo.size.height/4))
								.offset(x: movePointToScore ? geo.size.width/2.3 : 0, y: movePointToScore ? -geo.size.height/13 : 0)
								.opacity(movePointToScore ? 0 : 1)
								.onAppear {
									withAnimation(
										.easeInOut(duration: 1).delay(3)) {
											movePointToScore = true
										}
								}
						}
					}
					.animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)
					
					Spacer()
					
					VStack {
						if tappedCorrectAnswer {
							Text("Brilliant!")
								.font(.custom(Constants.hpFont, size: 100))
								.transition(.scale.combined(with: .offset(y: -geo.size.height/2)))
						}
					}
					.animation(.easeInOut(duration: 1).delay(1), value: tappedCorrectAnswer)
					
					Spacer()
					
					if tappedCorrectAnswer {
						Text("Answer 1")
							.minimumScaleFactor(0.5)
							.multilineTextAlignment(.center)
							.padding(10)
							.frame(width: geo.size.width/2.15, height: 80)
							.background(.green.opacity(0.5))
							.cornerRadius(25)
							.scaleEffect(2)
					}
						
					Spacer()
					Spacer()
					
					Group {
						VStack {
							if tappedCorrectAnswer {
								Button("Next Level >") {
									// TODO: Reset Level for next question
								}
								.buttonStyle(.borderedProminent)
								.tint(.blue.opacity(0.5))
								.font(.largeTitle)
								.transition(.offset(y: geo.size.height/3))
								.scaleEffect(scaleNextButton ? 1.2 : 1)
								.onAppear {
									withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
										scaleNextButton.toggle()
									}
								}
							}
						}
						.animation(.easeInOut(duration: 2.7).delay(2.7), value: tappedCorrectAnswer)
						
						Spacer()
						Spacer()
					}
				}
				.foregroundColor(.white)
			}
			.frame(width: geo.size.width, height: geo.size.height)
		}
		.ignoresSafeArea()
		.onAppear {
//			animateViewsIn = true
			tappedCorrectAnswer = true
		}
	}
}

struct Gameplay_Previews: PreviewProvider {
    static var previews: some View {
		VStack {
			Gameplay()
		}
    }
}
