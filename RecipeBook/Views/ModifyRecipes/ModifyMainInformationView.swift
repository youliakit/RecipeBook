//
//  ModifyMainInformationView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 22.02.26.
//  Modifies the mainInformation component of a recipe which includes its name, author, description and category

import SwiftUI

struct ModifyMainInformationView: View {
	private let listBackgroundColor = AppColor.background
	private let listTextColor = AppColor.foreground

	@Binding var mainInformation: MainInformation

	var body: some View {
		NavigationView {
			Form {
				TextField("Recipe name", text: $mainInformation.name)
					.listRowBackground(listBackgroundColor)
				TextField("Author", text: $mainInformation.author)
					.listRowBackground(listBackgroundColor)
				Section(header: Text("Description")) {
					TextEditor(text: $mainInformation.description)
						.listRowBackground(listBackgroundColor)
				}
				Picker(selection: $mainInformation.category, label:
						HStack {
					Text("Category")
					Spacer()
					Text(mainInformation.category.rawValue)
				}) {
					ForEach(MainInformation.Category.allCases, id: \.self) {
						category in
						Text(category.rawValue)
					}
				}
				.listRowBackground(listBackgroundColor)
				.pickerStyle(MenuPickerStyle())
			}
			.foregroundColor(listTextColor)
		}
	}
}


struct ModifyMainInformation_Preview: PreviewProvider {
	static let testPlaceholder: String = "Test"
	
	@State static var emptyInformation = MainInformation(
		name: "",
		description: "",
		author: "",
		category: .breakfast
	)
	@State static var mainInformation = MainInformation(
		name: testPlaceholder,
		description: testPlaceholder,
		author: testPlaceholder,
		category: .breakfast
	)
	static var previews: some View {
		ModifyMainInformationView(mainInformation: $mainInformation)
		ModifyMainInformationView(mainInformation: $emptyInformation)
	}

}
