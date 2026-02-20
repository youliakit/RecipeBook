//
//  ContentView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 15.02.26.
//

import SwiftUI



struct RecipesListView: View {
	/*
	 By passing an object through the environment, the current view and any children views can access that object. Here, RecipeCategoryGridView will hold now the recipeData object.
	 Since RecipesListView will be a child view, RecipesListView will access that data through the environment using the @EnvironmentObject property wrapper
	 */
	@EnvironmentObject private var recipeData: RecipeData
	let category: MainInformation.Category

	// If something is only used internally -- mark it private!
	@State private var isPresenting = false
	@State private var newRecipe = Recipe()

	// Colors
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) {
                    recipe in
                    NavigationLink(recipe.mainInformation.name, destination: RecipeDetailView(recipe: recipe))
                }
                .listRowBackground(listBackgroundColor)
                .foregroundColor(listTextColor)
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)

			.toolbar(content: {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						isPresenting = true
					}, label: {
						Image(systemName: "plus") // Default SF symbol for +
					})
				}
			})
			.sheet(isPresented: $isPresenting, content: {
				NavigationView {
					ModifyRecipeView(recipe: $newRecipe)
						.toolbar(content: {
							ToolbarItem(placement: .navigationBarTrailing) {
								Button("Dismiss") {
									isPresenting = false
								}
							}
							ToolbarItem(placement: .navigationBarLeading) {
								if newRecipe.isValid {
									Button("Add") {
										recipeData.add(recipe: newRecipe)
										isPresenting = false
									}
								}
							}
						})
				}
				.navigationTitle("Add a new recipe")
			})
        }
    }
}

extension RecipesListView {
	/*
	 The new category property is the Category to display that the grid will pass in. The new function, recipes(for:), was created to filter recipes by category. Then, the recipes property calls this function to return the recipes filtered by the category.
	 */
    private var recipes: [Recipe] {
		recipeData.recipes(for: category)
    }

    // Title includes the specific category
    private var navigationTitle: String {
		"\(category.rawValue) Recipes"
    }
}

struct RecipesListView_Previews: PreviewProvider {
  static var previews: some View {
	NavigationView {
	  RecipesListView(category: .breakfast)
		.environmentObject(RecipeData())
	}
  }
}
