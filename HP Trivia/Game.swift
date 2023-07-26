//
//  Game.swift
//  HP Trivia
//
//  Created by NazarStf on 26.07.2023.
//

import Foundation

@MainActor
class Game: ObservableObject {
	private var allQuestions: [Question] = []
	private var answeredQuestions: [Int] = []
	
	var filteredQuestions: [Question] = []
	var currentQuestion = Constants.previewQustion
	var answers: [String] = []
	
	var correctAnswer: String {
		currentQuestion.answers.first(where: { $0.value == true })!.key
	}
	
	init() {
		decodeQuestions()
	}
	
	func filterQuestions(to books: [Int]) {
		filteredQuestions = allQuestions.filter { books.contains($0.book) }
	}
	
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
	}
	
	func correct() {
		answeredQuestions.append(currentQuestion.id)
		
		// TODO: Update score
	}
	
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
