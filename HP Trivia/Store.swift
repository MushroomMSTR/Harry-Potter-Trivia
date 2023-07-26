//
//  Store.swift
//  HP Trivia
//
//  Created by NazarStf on 25.07.2023.
//

import Foundation
import StoreKit

enum BookStatus: Codable {
	case active
	case inactive
	case locked
}

@MainActor
class Store: ObservableObject {
	@Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
	@Published var products: [Product] = []
	@Published var purchasedIDs = Set<String>()
	
	private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
	private var updates: Task<Void, Never>? = nil
	private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")
	
	init() {
		updates = watchForUpdates()
	}
	
	func loadProducts() async {
		do {
			products = try await Product.products(for: productIDs)
		} catch {
			print("Couldn't fetch those products: \(error)")
		}
	}
	
	func purchase(_ product: Product) async {
		do {
			let result = try await product.purchase()
			
			switch result {
			case .success(let verificationResult):
				switch verificationResult {
				case .unverified(let signedType, let verificationError):
					print("Error on \(signedType): \(verificationError)")
				case .verified(let signedType):
					purchasedIDs.insert(signedType.productID)
				}
			case .userCancelled:
				break
			case .pending:
				break
			@unknown default:
				break
			}
		} catch {
			print("Couldn't purchase that product: \(error)")
		}
	}
	
	func saveStatus() {
		do {
			let data = try JSONEncoder().encode(books)
			try data.write(to: savePath)
		} catch {
			print("Unable to save data.")
		}
	}
	
	func loadStatus() {
		do {
			let data = try Data(contentsOf: savePath)
			books = try JSONDecoder().decode([BookStatus].self, from: data)
		} catch {
			print("Couldn't load book statuses.")
		}
	}
	
	private func checkPurchased() async {
		for product in products {
			guard let state = await product.currentEntitlement else { return }
			
			switch state {
			case .unverified(let signedType, let verificationError):
				print("Error on \(signedType): \(verificationError)")
				
			case .verified(let signedType):
				if signedType.revocationDate == nil {
					purchasedIDs.insert(signedType.productID)
				} else {
					purchasedIDs.remove(signedType.productID)
				}
			}
		}
	}
	
	private func watchForUpdates() -> Task<Void, Never> {
		Task(priority: .background) {
			for await _ in Transaction.updates {
				await checkPurchased()
			}
		}
	}
}
