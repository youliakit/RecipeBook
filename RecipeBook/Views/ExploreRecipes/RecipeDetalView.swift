//
//  RecipeDetalView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 17.02.26.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
	@Binding var recipe: Recipe
	@Binding var recipeData: RecipeData

	@State private var isPresenting = false // track when ModifyRecipeView sheet should be presented

	@AppStorage("hideOptionalSteps") private var hideOptionalSteps: Bool = false
	@AppStorage("listBackgroudColour") private var listBackgroudColour = AppColour.background
	@AppStorage("listTextColour") private var listTextColour = AppColour.foreground

	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Text("Author: \(recipe.mainInformation.author)")
						.font(.subheadline)
						.padding()
					Spacer()
				}
				HStack {
					Text(recipe.mainInformation.description)
						.font(.subheadline)
						.padding()
					Spacer()
				}
				List {
					Section(header: Text("Ingredients")) {
						ForEach(recipe.ingredients.indices, id: \.self) {
							index in
							let ingredient = recipe.ingredients[index]
							Text(ingredient.description)
								.foregroundColor(listTextColour)
						}
					}.listRowBackground(listBackgroudColour)
					Section(header: Text("Directions")) {
						ForEach(recipe.directions.indices, id: \.self) {
							index in
							let direction = recipe.directions[index]
							// Hide optional steps based on user selection
							if direction.isOptional && hideOptionalSteps {
								EmptyView()
							} else {
								HStack {
									let index = recipe.index(
										of: direction,
										excludingOptionalDirections: hideOptionalSteps
									) ?? 0
									Text("\(index + 1). ").bold()
									Text("\(direction.isOptional ? "(Optional)" : "")" + "\(direction.description)")
								}.foregroundColor(listTextColour)
							}
						}
					}.listRowBackground(listBackgroudColour)
				}
			}
			.navigationTitle(recipe.mainInformation.name)
			.navigationBarTitleDisplayMode(.large)
			
			// toolbar containing 'Edit' button
			.toolbar {
				ToolbarItem {
					HStack {
						Button("📝") {
							isPresenting = true
						}
						Button(action: {
							recipe.isFavourite.toggle()
						}) {
							Text(recipe.isFavourite ? "❤️" : "🩶")
						}
					}
				}
			}
			
			// present ModifyRecipeView when the 'Edit' button is tapped
			.sheet(isPresented: $isPresenting) {
				NavigationView {
					ModifyRecipeView(recipe: $recipe)
						.toolbar {
							ToolbarItem(placement: .confirmationAction) {
								Button("Save") {
									isPresenting = false
								}
							}
						}
						.navigationTitle("Edit recipe")
				}
				// if recipe is modified, the modification will persist
				.onDisappear {
					recipeData.saveRecipes()
				}
			}
		}
	}
}

struct RecipeDetailView_Previews: PreviewProvider {
	@State static var recipe = Recipe.testRecipes[0]
	@State static var recipeData = RecipeData()
	
	static var previews: some View {
		NavigationView {
			RecipeDetailView(recipe: $recipe, recipeData: $recipeData)
		}
	}
}
