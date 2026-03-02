//
//  AppColour.swift
//  RecipeBook
//
//  Created by 𝒴𝑜𝓊𝓁𝒾𝒶 𝒯𝒾𝑔𝓇𝒶𝓃𝓎𝒶𝓃 on 17.02.26.
//  Making App colour conform to RawRepresentable

import SwiftUI // Allows the Color structure to be referenced
import Foundation

struct AppColor {
	static let background: Color = Color(.sRGB,
										 red: 255/255,
										 green: 233/255,
										 blue: 255/255,
										 opacity: 1)
	static let foreground: Color = Color(.sRGB,
										 red: 255/255,
										 green: 0/255,
										 blue: 255/255,
										 opacity: 1)
}

/*
 To wrap a property with the @AppStorage property wrapper, the type must already be supported by the @AppStorage property wrapper, or conform to RawRepresentable. Color is not by default supported by the @AppStorage property wrapper, so you need to add conformance to RawRepresentable.
 */
extension Color: RawRepresentable {
	// rawValue property converts Color into a String
	public init?(rawValue: String) {
		do {
			// encode the Color into a String
			let encodedData = rawValue.data(using: .utf8)!

			/* Convert the rawValue back into Data
			 Use JSONDecoder to decode the Data into an array of Doubles representing the RGB and alpha components
			 */
			let components = try JSONDecoder().decode(
				[Double].self,
				from: encodedData
			)

			// convert the String back into a Color object by building a Color out of the components
			self = Color(
				red: components[0],
				green: components[1],
				blue: components[2],
				opacity: components[3]
			)
		}
		catch {
			return nil
		}
	}

	// Converts a Color to String so it can be stored in UserDefaults
	public var rawValue: String {
		guard let cgFloatComponents = UIColor(self).cgColor.components else {return ""}
		let doubleComponents = cgFloatComponents.map { Double($0) }
		do {
			// Convert the array into JSON Data
			let encodedComponents = try JSONEncoder().encode(doubleComponents)

			// RawRepresentable requires String so we convert the encoded data to a String
			return String(data: encodedComponents, encoding: .utf8) ?? ""
		}
		catch {
			return ""
		}
	}
}
