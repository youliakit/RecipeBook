//
//  RecipeData.swift
//  Cookcademy
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 17.02.26.
//

import Foundation
import Combine

class RecipeData: ObservableObject {
  @Published var recipes = Recipe.testRecipes

  func recipes(for category: MainInformation.Category) -> [Recipe] {
	var filteredRecipes = [Recipe]()
	for recipe in recipes {
	  if recipe.mainInformation.category == category {
		filteredRecipes.append(recipe)
	  }
	}
	  return filteredRecipes
  }
}
