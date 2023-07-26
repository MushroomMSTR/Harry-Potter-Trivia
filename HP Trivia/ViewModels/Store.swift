//
//  Store.swift
//  HP Trivia
//
//  Created by NazarStf on 25.07.2023.
//

import Foundation
import StoreKit

// MARK: - Enum BookStatus
// An enumeration that defines the possible states of each book.
enum BookStatus: Codable {
	case active
	case inactive
	case locked
}

// MARK: - Class Store
// This class is responsible for managing the status of books and in-app purchases.
@MainActor
class Store: ObservableObject {
	// Published variables that will cause the UI to update when they change.
	@Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
	@Published var products: [Product] = [] // Products fetched from the App Store
	@Published var purchasedIDs = Set<String>() // Set of IDs for the purchased products

	private var productIDs = ["hp4", "hp5", "hp6", "hp7"] // IDs for the products in the App Store
	private var updates: Task<Void, Never>? = nil // A task that watches for updates in purchase transactions
	private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus") // File path to save the status of books

	// MARK: - Initialization
	init() {
		updates = watchForUpdates() // Begin watching for updates in purchase transactions
	}

	// MARK: - Fetch products from App Store
	func loadProducts() async {
		do {
			products = try await Product.products(for: productIDs) // Fetch the products from the App Store using their IDs
		} catch {
			print("Couldn't fetch those products: \(error)") // Handle any errors that occur while fetching products
		}
	}

	// MARK: - Make a purchase
	func purchase(_ product: Product) async {
		do {
			let result = try await product.purchase() // Attempt to purchase the product

			switch result {
			case .success(let verificationResult):
				switch verificationResult {
				case .unverified(let signedType, let verificationError):
					print("Error on \(signedType): \(verificationError)") // Handle any errors that occur during the verification process
				case .verified(let signedType):
					purchasedIDs.insert(signedType.productID) // If the purchase is verified, add the product ID to the set of purchased IDs
				}
			case .userCancelled:
				break
			case .pending:
				break
			@unknown default:
				break
			}
		} catch {
			print("Couldn't purchase that product: \(error)") // Handle any errors that occur while attempting to purchase the product
		}
	}

	// MARK: - Save the status of books
	func saveStatus() {
		do {
			let data = try JSONEncoder().encode(books) // Encode the status of books into data
			try data.write(to: savePath) // Write the data to the specified file path
		} catch {
			print("Unable to save data.") // Handle any errors that occur while saving the data
		}
	}

	// MARK: - Load the status of books
	func loadStatus() {
		do {
			let data = try Data(contentsOf: savePath) // Fetch the data from the specified file path
			books = try JSONDecoder().decode([BookStatus].self, from: data) // Decode the data into the status of books
		} catch {
			print("Couldn't load book statuses.") // Handle any errors that occur while loading the book statuses
		}
	}

	// MARK: - Check if products have been purchased
	private func checkPurchased() async {
		for product in products {
			guard let state = await product.currentEntitlement else { return } // Fetch the current entitlement of the product

			switch state {
			case .unverified(let signedType, let verificationError):
				print("Error on \(signedType): \(verificationError)") // Handle any errors that occur during the verification process
			case .verified(let signedType):
				// If the purchase has not been revoked, add the product ID to the set of purchased IDs
				// Otherwise, remove the product ID from the set of purchased IDs
				if signedType.revocationDate == nil {
					purchasedIDs.insert(signedType.productID)
				} else {
					purchasedIDs.remove(signedType.productID)
				}
			}
		}
	}

	// MARK: - Watch for updates in purchase transactions
	private func watchForUpdates() -> Task<Void, Never> {
		Task(priority: .background) {
			for await _ in Transaction.updates { // Watch for updates in purchase transactions
				await checkPurchased() // Check if products have been purchased whenever there is an update
			}
		}
	}
}
