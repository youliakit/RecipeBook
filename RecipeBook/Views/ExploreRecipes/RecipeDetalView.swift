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
	
	@State private var isPresenting = false // track when ModifyRecipeView sheet should be presented
	
	private let listBackgroudColor = AppColor.background
	private let listTextColor = AppColor.foreground
	
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
								.foregroundColor(listTextColor)
						}
					}.listRowBackground(listBackgroudColor)
					Section(header: Text("Directions")) {
						ForEach(recipe.directions.indices, id: \.self) {
							index in
							let direction = recipe.directions[index]
							HStack {
								Text("\(index + 1). ").bold()
								Text("\(direction.isOptional ? "(Optional)" : "")" + "\(direction.description)")
							}.foregroundColor(listTextColor)
						}
					}.listRowBackground(listBackgroudColor)
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
			}
		}
	}
}

struct RecipeDetailView_Previews: PreviewProvider {
	@State static var recipe = Recipe.testRecipes[0]
	static var previews: some View {
		NavigationView {
			RecipeDetailView(recipe: $recipe)
		}
	}
}
