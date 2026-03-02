//
//  SettingsView.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 02.03.26.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("hideOptionalSteps") private var hideOptionalSteps: Bool = false
	@AppStorage("listBackgroundColor") private var listBackgroundColour = AppColour.background
	@AppStorage("listTextColor") private var listTextColour = AppColour.foreground

	var body: some View {
		NavigationView {
			Form {
				ColorPicker(
					"List Background colour",
					selection: $listBackgroundColour
				)
				.padding()
				.listRowBackground(listBackgroundColour)
				ColorPicker("Text colour", selection: $listTextColour)
					.padding()
					.listRowBackground(listBackgroundColour)
				Toggle("Hide optional steps", isOn: $hideOptionalSteps)
					.padding()
					.listRowBackground(listBackgroundColour)
			}
			.foregroundColor(listTextColour)
			.navigationTitle("Settings")
		}
	}
}


struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
