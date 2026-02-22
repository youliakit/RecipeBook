//
//  ModifyRecipeView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 20.02.26.
//

import SwiftUI

enum Selection {
	case main
	case ingredients
	case directions
}

struct ModifyRecipeView: View {
	/* Without @Binding, changes here would not propagate back
	 - The binding allows ModifyRecipeView to access and modify the original property as if it owned recipe
	 - Once ModifyRecipeView is done, it doesn’t need to send any recipe data back to RecipesListView since it was already owned by RecipesListView
	 */
	@Binding var recipe: Recipe // this view does not own the recipe data

	@State private var selection = Selection.main

	var body: some View {
		VStack {
			Picker("Select recipe component", selection: $selection) {
				Text("Main info").tag(Selection.main)
				Text("Ingredients").tag(Selection.ingredients)
				Text("Directions").tag(Selection.directions)
			}
			.pickerStyle(SegmentedPickerStyle())
			.padding()

			switch selection {
			case .main:
				ModifyMainInformationView(
					mainInformation: $recipe.mainInformation
				)
			case .ingredients:
				Text("Ingredients editor")
			case .directions:
				Text("Directions editor")
			}
			Spacer()
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
