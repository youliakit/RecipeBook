//
//  ModifyDirectionView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 27.02.26.
//  Changes one direction at a time

import SwiftUI

struct ModifyDirectionView: ModifyComponentView {
	@Binding var direction: Direction // Using @Binding to edit Direction inside of Recipe structure, without it we would edit the copy
	let createAction: (Direction) -> Void // allows parent(Recipe model) to decide what 'Save' means
	
	private let listBackgroundColour = AppColour.background
	private let listTextColour = AppColour.foreground

	init(component: Binding<Direction>, createAction: @escaping (Direction) -> Void) {
		self._direction = component
		self.createAction = createAction
	}
	
	@Environment(\.presentationMode) private var mode // gives access to the sheet's presentation state
	
	var body: some View {
		Form {
			TextField("Direction Description", text: $direction.description) // direction is Binding<Direction>, but SwiftUI supports dynamic member lookup so we do $direction.description and it becomes Binding<String>
				.listRowBackground(listBackgroundColour)
			Toggle("Optional", isOn: $direction.isOptional)
				.listRowBackground(listBackgroundColour)
			HStack {
				Spacer()
				Button("Save") {
					createAction(direction) // When "Save" is pressed we pass the edited direction back to parent and parent decides what to do
					mode.wrappedValue.dismiss() // telling SwiftUI to close this sheet
				}
				Spacer()
			}.listRowBackground(listBackgroundColour)
		}
		.foregroundColor(listTextColour)
	}
}

struct ModifyDirectionView_Previews: PreviewProvider {
	@State static var emptyDirection = Direction(description: "", isOptional: false)  // changed to new empty initializer
	
	static var previews: some View {
		NavigationView { ModifyDirectionView(component: $emptyDirection) {
			_ in return
		}
		}
	}
}
