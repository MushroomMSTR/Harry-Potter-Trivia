//
//  Question.swift
//  HP Trivia
//
//  Created by NazarStf on 25.07.2023.
//

// Import the Foundation framework. This framework provides basic functionality
// such as string and array processing, date and time handling, etc.
import Foundation

// MARK: - Question

// Define a struct named 'Question' which conforms to the 'Codable' protocol.
// This means that instances of Question can be encoded to and decoded from
// different external representations such as JSON.
struct Question: Codable {
	// Declare properties of the struct. These represent the various fields
	// of a trivia question.
	let id: Int
	let question: String
	var answers: [String: Bool] = [:]
	let book: Int
	let hint: String
	
	// MARK: - QuestionKeys
	
	// Define an enumeration called 'QuestionKeys'. This is used to map the
	// JSON keys in the data to the properties of the 'Question' struct.
	enum QuestionKeys: String, CodingKey {
		case id
		case question
		case answer
		case wrong
		case book
		case hint
	}
	
	// MARK: - Initializer
	
	// Define a custom initializer for the struct. This initializer takes an
	// instance of 'Decoder', which is used to decode the JSON data.
	init(from decoder: Decoder) throws {
		// Create a decoding container using the 'QuestionKeys' enumeration
		// as the keys. This container is used to decode the data.
		let container = try decoder.container(keyedBy: QuestionKeys.self)
		
		// Decode each property from the container using the associated key.
		id = try container.decode(Int.self, forKey: .id)
		question = try container.decode(String.self, forKey: .question)
		book = try container.decode(Int.self, forKey: .book)
		hint = try container.decode(String.self, forKey: .hint)
		
		// Decode the correct answer and add it to the 'answers' dictionary
		// with a value of 'true'.
		let correctAnswer = try container.decode(String.self, forKey: .answer)
		answers[correctAnswer] = true
		
		// Decode the wrong answers, which is an array of strings, and add
		// each one to the 'answers' dictionary with a value of 'false'.
		let wrongAnswers = try container.decode([String].self, forKey: .wrong)
		for answer in wrongAnswers {
			answers[answer] = false
		}
	}
}
