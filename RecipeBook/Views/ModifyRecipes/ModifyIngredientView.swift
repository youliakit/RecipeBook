//
//  ModifyIngredientView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 22.02.26.
//  Modifies the ingredient component of a recipe

import SwiftUI

// NumberFormatter() transforms the user's string into a number
extension NumberFormatter {
	// This extension returns a new format with a specific style
	static var decimal: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}
}


struct ModifyIngredientView: ModifyComponentView {

	@Binding var ingredient: Ingredient // Binding, because this view gets its ingredient from a different view
	@Environment(\.presentationMode) private var mode // dismiss View when the button is tapped

	let createAction: ((Ingredient) -> Void)


	init(component: Binding<Ingredient>, createAction: @escaping (Ingredient) -> Void) {
		self._ingredient = component // Assign a value to the ingredient property marked with @Binding property wrapper
		self.createAction = createAction
	}

	// Colors
	private let listBackgroundColor = AppColor.background
	private let listTextColor = AppColor.foreground

	var body: some View {
		VStack {
			Form {
				TextField("Ingredient name", text: $ingredient.name)
					.listRowBackground(listBackgroundColor)
				Stepper(value: $ingredient.quantity, in: 0...100, step: 0.5) {
					HStack {
						Text("Quantity:")
						TextField(
							"Quantity",
							value: $ingredient.quantity,
							formatter: NumberFormatter.decimal
						).keyboardType(.numbersAndPunctuation)
						// The value of quantity can be changed either by typing in a number directly or by using the stepper -/+
					}
				} .listRowBackground(listBackgroundColor)
				Picker(selection: $ingredient.unit, label:
					HStack {
						Text("Unit")
						Spacer()
						Text(ingredient.unit.rawValue)
				}) {
					ForEach(Ingredient.Unit.allCases, id: \.self) { unit in
						Text(unit.rawValue)
					}
				}
				.listRowBackground(listBackgroundColor)
				.pickerStyle(MenuPickerStyle())

				HStack {
					Spacer()
					Button("Save") {
						createAction(ingredient)
						mode.wrappedValue.dismiss()
					}
					Spacer()
				} .listRowBackground(listBackgroundColor)
			}
			.foregroundColor(listTextColor)
		}
	}
}




struct ModifyIngredientView_Preview: PreviewProvider {
	@State static var emptyIngredient = Recipe.testRecipes[0].ingredients[0]

	static var previews: some View {
		NavigationView {
			ModifyIngredientView(component: $emptyIngredient){
				Ingredient in
				print(Ingredient)
			}
		}.navigationTitle("Add Ingredient")
	}
}


struct ModifyIngredientView_Previews: PreviewProvider {
	@State static var recipe = Recipe.testRecipes[0]
	static var previews: some View {
		NavigationView {
		   ModifyIngredientView(component: $recipe.ingredients[0]) { ingredient in
				print(ingredient)
			}.navigationTitle("Add Ingredient")
		}
	}
}
