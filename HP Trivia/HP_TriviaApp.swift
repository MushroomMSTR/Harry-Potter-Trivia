//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by NazarStf on 21.07.2023.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
	
	@StateObject private var store = Store()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(store)
				.task {
					await store.loadProducts()
				}
        }
    }
}
