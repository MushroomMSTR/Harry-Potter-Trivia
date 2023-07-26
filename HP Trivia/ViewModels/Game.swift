//
//  Game.swift
//  HP Trivia
//
//  Created by NazarStf on 26.07.2023.
//

import Foundation
import SwiftUI

// MARK: - Game class
@MainActor
class Game: ObservableObject {

	// These published properties will update the UI when they change
	@Published var gameScore = 0
	@Published var questionScore = 5
	@Published var recentScores = [0,0,0]

	// Other necessary variables for the game logic
	private var allQuestions: [Question] = [] // all questions from the JSON file
	private var answeredQuestions: [Int] = [] // questions already answered
	private let savePath = FileManager.documentsDirectory.appending(path: "SavedScores") // path to save scores

	// Variables for the current game round
	var filteredQuestions: [Question] = [] // questions filtered by selected books
	var currentQuestion = Constants.previewQustion // the current question
	var answers: [String] = [] // current possible answers

	// The correct answer for the current question
	var correctAnswer: String {
		currentQuestion.answers.first(where: { $0.value == true })!.key
	}

	// MARK: - Initialization
	init() {
		decodeQuestions()
	}

	// MARK: - Game logic functions

	// Starts a new game by resetting scores and answered questions
	func startGame() {
		gameScore = 0
		questionScore = 5
		answeredQuestions = []
	}

	// Filters questions according to selected books
	func filterQuestions(to books: [Int]) {
		filteredQuestions = allQuestions.filter { books.contains($0.book) }
	}
	
	// Generates a new question and shuffles possible answers
	func newQuestion() {
		if filteredQuestions.isEmpty {
			return
		}
		
		if answeredQuestions.count == filteredQuestions.count {
			answeredQuestions = []
		}
		
		var potentialQuestion = filteredQuestions.randomElement()!
		while answeredQuestions.contains(potentialQuestion.id) {
			potentialQuestion = filteredQuestions.randomElement()!
		}
		currentQuestion = potentialQuestion
		
		answers = []
		
		for answer in currentQuestion.answers.keys {
			answers.append(answer)
		}
		
		answers.shuffle()
		
		questionScore = 5
	}
	
	// Marks the current question as correct and adds the question score to the game score
	func correct() {
		answeredQuestions.append(currentQuestion.id)
		
		withAnimation {
			gameScore += questionScore
		}
	}
	
	// Ends the game and saves the game score to recent scores
	func endGame() {
		recentScores[2] = recentScores[1]
		recentScores[1] = recentScores[0]
		recentScores[0] = gameScore
		
		saveScores()
	}
	
	// Loads the recent scores from saved data
	func loadScores() {
		do {
			let data = try Data(contentsOf: savePath)
			recentScores = try JSONDecoder().decode([Int].self, from: data)
		} catch {
			recentScores = [0,0,0]
		}
	}
	
	// MARK: - Private functions for saving and decoding data
	
	// Saves the recent scores to a file
	private func saveScores() {
		do {
			let data = try JSONEncoder().encode(recentScores)
			try data.write(to: savePath)
		} catch {
			print("Unable to save data: \(error)")
		}
	}
	
	// Decodes the questions from a JSON file
	private func decodeQuestions() {
		if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
			do {
				let data = try Data(contentsOf: url)
				let decoder = JSONDecoder()
				allQuestions = try decoder.decode([Question].self, from: data)
				filteredQuestions = allQuestions
			} catch {
				print("Error decoding JSON data: \(error)")
			}
		}
	}
}
