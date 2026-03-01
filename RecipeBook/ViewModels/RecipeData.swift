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
}
