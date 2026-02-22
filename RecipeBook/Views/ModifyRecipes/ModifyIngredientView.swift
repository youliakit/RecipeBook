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


struct ModifyIngredientsView: View {
	@Binding var ingredients: [Ingredient]
	@State private var newIngredient = Ingredient()

	// Colors
	private let listBackgroundColor = AppColor.background
	private let listTextColor = AppColor.foreground

	var body: some View {
		VStack {
			if ingredients.isEmpty {
				Spacer()
				NavigationLink(
					"Add the first ingredient",
					destination: ModifyIngredientView(
						ingredient: $newIngredient
					) { ingredient in
						ingredients.append(newIngredient)
						newIngredient = Ingredient(
							name: "",
							quantity: 0.0,
							unit: .none
						)
					}
				)
			} else {
				List {
					ForEach(ingredients.indices, id: \.self) { index in
						let ingredient = ingredients[index]
						Text(ingredient.description)
					}
					NavigationLink(
						"Add another ingredient",
						destination: ModifyIngredientView(
							ingredient: $newIngredient
						) { ingredient in
							ingredients.append(newIngredient)
						 newIngredient = Ingredient(
							 name: "",
							 quantity: 0.0,
							 unit: .none
						 )
					 }
					)
					.listRowBackground(listBackgroundColor)
					.buttonStyle(PlainButtonStyle())
				} .listRowBackground(listBackgroundColor)
			}
		} .foregroundColor(listTextColor)
	}


}


struct ModifyIngredientView: View {

	@Binding var ingredient: Ingredient // Binding, because this view gets its ingredient from a different view
	@Environment(\.presentationMode) private var mode // dismiss View when the button is tapped

	let createAction: ((Ingredient) -> Void)

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
	@State static var emptyIngredient = Ingredient()

	static var previews: some View {
		NavigationView {
			ModifyIngredientView(ingredient: $emptyIngredient) {
				Ingredient in
				print(Ingredient)
			}
		}
	}
}



struct ModifyIngredientsView_Preview: PreviewProvider {
	@State static var emptyIngredients = [Ingredient]()

	static var previews: some View {
		NavigationView {
			ModifyIngredientsView(ingredients: $emptyIngredients)
		}
	}
}
