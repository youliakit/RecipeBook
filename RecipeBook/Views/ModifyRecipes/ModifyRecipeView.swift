//
//  ModifyRecipeView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 20.02.26.
//

import SwiftUI

struct ModifyRecipeView: View {
	// Without @Binding, changes here would not propagate back
	@Binding var recipe: Recipe // this view does not own the recipe data
	// The binding allows ModifyRecipeView to access and modify the original property as if it owned recipe
	// Once ModifyRecipeView is done, it doesn’t need to send any recipe data back to RecipesListView since it was already owned by RecipesListView
	var body: some View {
		Button("Fill in the recipe with test data") {
			recipe.mainInformation = MainInformation(
				name: "test",
				description: "test",
				author: "test",
				category: .breakfast
			) // update the original recipe stored in the parent view
			recipe.directions = [Direction(description: "test", isOptional: false)]
			recipe.ingredients = [Ingredient(name: "test", quantity: 1.0, unit: .none)]
		}
	}
}

struct ModifyRecipeView_Preview: PreviewProvider {
	// Previews cannot pass bindings directly unless they create state
	@State static var recipe = Recipe()
	static var previews: some View {
		ModifyRecipeView(recipe: $recipe)
	}
}
