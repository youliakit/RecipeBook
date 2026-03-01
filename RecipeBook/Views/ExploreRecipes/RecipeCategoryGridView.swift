//
//  RecipeCategoryGridView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 18.02.26.
//  Recipe category selection grid view

import Foundation
import SwiftUI

// Making CategoryView organized and reusable
struct CategoryView: View {
	let category: MainInformation.Category
	
	var body: some View {
		ZStack {
			Image(category.rawValue.lowercased())
				.resizable()
				.aspectRatio(contentMode: .fit)
				.opacity(0.45)
			Text(category.rawValue)
				.font(.title)
		}
	}
	
}

struct RecipeCategoryGridView: View {
	@EnvironmentObject private var recipeData: RecipeData
	var body: some View {
		let columns = [GridItem(), GridItem()]
		NavigationView {
			ScrollView {
				LazyVGrid(
					columns: columns,
					content: {
						ForEach(MainInformation.Category.allCases,
								id: \.self) { category in
							NavigationLink(
								destination: RecipesListView(
									viewStyle: .singleCategory(category)
								),
								label: {
									CategoryView(category: category) // CategoryView is initiated for every category within ForEach
								}
							)
						}
					})
				.navigationTitle("Categories")
			}
		}
	}
}


struct RecipeCategoryGridView_Previews: PreviewProvider {
	static var previews: some View {
		RecipeCategoryGridView()
	}
}

