//
//  RecipeData.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 17.02.26.
//

import Foundation
import Combine

class RecipeData: ObservableObject {
	@Published var recipes = Recipe.testRecipes

	// computed property to filter recipes by their isFavourite property
	var favouriteRecipes: [Recipe] {
		recipes.filter { $0.isFavourite }
	}

	// Returns a URL of the stored file
	private var recipesFileURL: URL {
		do {
			let documentsDirectory = try FileManager.default.url(
				for: .documentDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
			)
			return documentsDirectory.appendingPathComponent("recipeData")
		} catch {
			fatalError("Failed to get the url: \t\(error)")
		}
	}

	func recipes(for category: MainInformation.Category) -> [Recipe] {
		var filteredRecipes = [Recipe]()
		for recipe in recipes {
			if recipe.mainInformation.category == category {
				filteredRecipes.append(recipe)
			}
		}
		return filteredRecipes
	}
	
	func add(recipe: Recipe) {
		if recipe.isValid {
			recipes.append(recipe)
		}
	}
	
	// Returns the index of a given recipe
	func index(of recipe: Recipe) -> Int? {
		for i in recipes.indices {
			if recipes[i].id == recipe.id {
				return i
			}
		}
		return nil
	}

	// Encodes recipes to JSON and saves them to the documents directory
	func saveRecipes() {
		do {
			let encodedData = try JSONEncoder().encode(recipes)
			try encodedData.write(to: recipesFileURL)
		} catch {
			fatalError("Failed to save recipes: \t\(error)")
		}
	}

	// Bring recipes back when the app relaunches
	func loadRecipes() {
		// Read contents of the initial recipes URL as data
		guard let data = try? Data(contentsOf: recipesFileURL) else { return }
		do {
			// decode the data into an array of Recipe
			let savedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
			// assign the recipes property to the saved recipes
			recipes = savedRecipes
		} catch {
			fatalError("Failed to load recipes: \t\(error)")
		}
	}

	// Save all the recipes whenever the user creates a new recipe
	func add(recipe: Recipe) {
		if recipe.isValid {
			recipes.append(recipe)
			saveRecipes()
		}
	}
}
