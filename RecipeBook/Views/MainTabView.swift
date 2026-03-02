//
//  MainTabView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 01.03.26.
//

import SwiftUI

struct MainTabView: View {
	/* Create this object once for the lifetime of this view and keep it alive
	     across redraws
	 Because the MainTabView will be the initial view the user sees, it should create and own the view model
	 */

	@StateObject var recipeData = RecipeData()

	var body: some View {
		TabView {
			RecipeCategoryGridView()
				.tabItem { Label("Recipes", systemImage: "list.dash") }

			// RecipeListView is embedded in a NavigationView so that the toolbar will display correctly at the top and it can present the recipe detail view
			NavigationView {
				RecipesListView(viewStyle: .favourites)
			} .tabItem {
				Label("Favs", systemImage: "heart.fill")
			}

			SettingsView()
			.tabItem {
				Label("Settings", systemImage: "gear")
			}
		}
		.environmentObject(recipeData)
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
	}
}
