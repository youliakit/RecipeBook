// Models the application


import Foundation

// Main structure of recipe
struct Recipe: Identifiable {
	var id = UUID()
	var mainInformation: MainInformation
	var ingredients: [Ingredient]
	var directions: [Direction]
	var isFavourite: Bool = false

	// Ensure that the recipe's key components are not empty
	var isValid: Bool {
		mainInformation.isValid && !ingredients.isEmpty && !directions.isEmpty
	}

	// Return correct display index
	func index(of direction: Direction, excludingOptionalDirections: Bool) -> Int? {
		// if excludingOptionalsDirections is
		// - true, then directions will include only the directions that are not optional
		// - false,then directions will include all of the directions, including the optional ones
		let directions = directions.filter { excludingOptionalDirections ? !$0.isOptional : true }
		// finds and returns the index that matches the description of the direction in the filtered directions array
		let index = directions.firstIndex { $0.description == direction.description }
		return index
	  }

	init(mainInformation: MainInformation, ingredients: [Ingredient], directions: [Direction]) {
		self.mainInformation = mainInformation
		self.ingredients = ingredients
		self.directions = directions
	}

	init() {
		self.init(mainInformation: MainInformation(name: "", description: "", author: "", category: .dessert), ingredients: [], directions: [])
	}
}

// Main information for single recipe
struct MainInformation {
	var name: String
	var description: String
	var author: String
	var category: Category

	var isValid: Bool {
		!name.isEmpty && !description.isEmpty && !author.isEmpty
	}

	// Enumeration that holds all the possible categories with String raw values
	enum Category: String, CaseIterable {
		case breakfast = "Breakfast"
		case lunch = "Lunch"
		case dinner = "Dinner"
		case dessert = "Dessert"
	}
}

// Separate structs for ingredients and directions as type of [String] won't let us store additional information with each ingredient or direction
struct Ingredient: RecipeComponent {
	var name: String
	var quantity: Double
	var unit: Unit

	// Computed property to describe ingredient in a readable format
	var description: String {
		// Return String from Double, the %g specifier suppresses trailing 0s
		// Example if we have 1.10000, it will turn our number to 1.1
		let formattedQuantity = String(format: "%g", quantity)
		switch unit {

			// if there are no units, we display formattedQuantity and name with no units
		case .none:
			return "\(formattedQuantity) \(quantity == 1 ? name : "\(name)s")"

			// if there are units and the quantity is exactly 1, then the singularName is used, otherwise the rawValue of the unit is used
		default:
			return quantity == 1 ? "1 \(unit.singularName) \(name)" : "\(formattedQuantity) \(unit.rawValue)"
		}
	}


	enum Unit: String, CaseIterable {
		case oz = "Ounces"
		case g = "Grams"
		case cups = "Cups"
		case tbs = "Tablespoons"
		case none = "No units"

		var singularName: String {String(rawValue.dropLast())} // dropLast removes the last character
	}

	init(name: String, quantity:Double, unit: Unit) {
		self.name = name
		self.quantity = quantity
		self.unit = unit
	}

	init() {
		self.init(name: "", quantity: 1.0, unit: .none)
	}

}

struct Direction: RecipeComponent {
	var description: String
	var isOptional: Bool // Adding nuts to a cookie might be optional, so this property will let us present that information to the user

	init(description: String, isOptional: Bool) {
		self.description = description
		self.isOptional = isOptional
	}

	init(){
		self.init(description: "", isOptional: false)
	}
}

extension Recipe {
	static let testRecipes: [Recipe] = [

		// MARK: - High-Protein Chicken Salad

		Recipe(
			mainInformation: MainInformation(
				name: "High-Protein Chicken Salad",
				description: "Light, high-protein salad with fresh vegetables.",
				author: "Youlia",
				category: .lunch
			),
			ingredients: [
				Ingredient(name: "Grilled chicken breast", quantity: 2, unit: .none),
				Ingredient(name: "Cherry tomatoes", quantity: 5, unit: .cups),
				Ingredient(name: "Cucumber", quantity: 3, unit: .none),
				Ingredient(name: "Avocado", quantity: 1, unit: .none),
				Ingredient(name: "Olive oil", quantity: 1, unit: .tbs),
				Ingredient(name: "Lemon juice", quantity: 1, unit: .tbs)
			],
			directions: [
				Direction(description: "Allow grilled chicken to rest for 5–10 minutes to retain juices before slicing.", isOptional: false),
				Direction(description: "Slice chicken breast into thin strips against the grain.", isOptional: false),
				Direction(description: "Wash cherry tomatoes thoroughly and cut them in halves.", isOptional: false),
				Direction(description: "Peel cucumbers if desired and dice into medium bite-sized cubes.", isOptional: false),
				Direction(description: "Cut avocado in half, remove the pit, and slice the flesh into cubes.", isOptional: false),
				Direction(description: "In a large mixing bowl combine chicken, tomatoes, cucumber, and avocado.", isOptional: false),
				Direction(description: "In a small bowl whisk olive oil and lemon juice until emulsified.", isOptional: false),
				Direction(description: "Pour dressing over salad and gently toss to avoid crushing avocado.", isOptional: false),
				Direction(description: "Taste and adjust seasoning if needed before serving.", isOptional: true)
			]
		),

		// MARK: - Warm Mushroom Salad

		Recipe(
			mainInformation: MainInformation(
				name: "Warm Mushroom Salad",
				description: "Savory mushroom salad with garlic and herbs.",
				author: "Youlia",
				category: .lunch
			),
			ingredients: [
				Ingredient(name: "Mushrooms", quantity: 300, unit: .g),
				Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
				Ingredient(name: "Fresh parsley", quantity: 1, unit: .tbs),
				Ingredient(name: "Salt", quantity: 1, unit: .none)
			],
			directions: [
				Direction(description: "Clean mushrooms using a damp paper towel and trim stem ends.", isOptional: false),
				Direction(description: "Slice mushrooms evenly to ensure uniform cooking.", isOptional: false),
				Direction(description: "Heat olive oil in a skillet over medium heat.", isOptional: false),
				Direction(description: "Add mushrooms in a single layer without overcrowding the pan.", isOptional: false),
				Direction(description: "Sauté for 5–7 minutes until mushrooms release moisture and become golden brown.", isOptional: false),
				Direction(description: "Season with salt during the final minute of cooking.", isOptional: false),
				Direction(description: "Remove from heat and sprinkle freshly chopped parsley over the top.", isOptional: false),
				Direction(description: "Serve warm as a side dish or light lunch.", isOptional: false)
			]
		),

		// MARK: - Armenian Spas

		Recipe(
			mainInformation: MainInformation(
				name: "Armenian Yogurt Soup (Spas)",
				description: "Traditional Armenian soup with matsun, egg, flour and greens.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Matsun (plain yogurt)", quantity: 500, unit: .g),
				Ingredient(name: "Sour cream", quantity: 2, unit: .tbs),
				Ingredient(name: "Egg", quantity: 1, unit: .none),
				Ingredient(name: "Flour", quantity: 2, unit: .tbs),
				Ingredient(name: "Water", quantity: 3, unit: .cups),
				Ingredient(name: "Fresh greens", quantity: 1, unit: .cups)
			],
			directions: [
				Direction(description: "In a large pot whisk matsun, sour cream, egg, and flour until completely smooth with no lumps.", isOptional: false),
				Direction(description: "Gradually add water while whisking continuously to prevent curdling.", isOptional: false),
				Direction(description: "Place pot over low heat and stir constantly using a wooden spoon.", isOptional: false),
				Direction(description: "Continue stirring until mixture begins to gently simmer.", isOptional: false),
				Direction(description: "Cook for 10–15 minutes until soup slightly thickens.", isOptional: false),
				Direction(description: "Finely chop fresh greens and add to soup.", isOptional: false),
				Direction(description: "Simmer an additional 5 minutes.", isOptional: false),
				Direction(description: "Remove from heat and allow to rest before serving warm.", isOptional: false)
			]
		),

		// MARK: - Crispy Fried Chicken

		Recipe(
			mainInformation: MainInformation(
				name: "Crispy Fried Chicken",
				description: "Homemade KFC-style crispy chicken.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Chicken pieces", quantity: 1, unit: .none),
				Ingredient(name: "Flour", quantity: 2, unit: .cups),
				Ingredient(name: "Eggs", quantity: 2, unit: .none),
				Ingredient(name: "Paprika", quantity: 1, unit: .tbs),
				Ingredient(name: "Salt", quantity: 1, unit: .tbs)
			],
			directions: [
				Direction(description: "Pat chicken pieces dry with paper towels.", isOptional: false),
				Direction(description: "Season chicken evenly with salt and paprika.", isOptional: false),
				Direction(description: "Beat eggs in a separate bowl until smooth.", isOptional: false),
				Direction(description: "Place flour in another bowl and mix with additional seasoning if desired.", isOptional: false),
				Direction(description: "Dip each chicken piece into beaten eggs, allowing excess to drip off.", isOptional: false),
				Direction(description: "Coat thoroughly in seasoned flour and press to adhere.", isOptional: false),
				Direction(description: "Heat oil to 170–180°C in a deep fryer or heavy pot.", isOptional: false),
				Direction(description: "Fry chicken in batches for 12–15 minutes until golden brown and fully cooked.", isOptional: false),
				Direction(description: "Transfer to wire rack to drain excess oil before serving.", isOptional: false)
			]
		),

		// MARK: - Russian Borscht

		Recipe(
			mainInformation: MainInformation(
				name: "Russian Borscht",
				description: "Traditional beet soup with vegetables and beef broth.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Beets", quantity: 2, unit: .none),
				Ingredient(name: "Potatoes", quantity: 2, unit: .none),
				Ingredient(name: "Carrot", quantity: 1, unit: .none),
				Ingredient(name: "White cabbage (shredded)", quantity: 2, unit: .cups),
				Ingredient(name: "Onion", quantity: 1, unit: .none),
				Ingredient(name: "Beef broth", quantity: 4, unit: .cups),
				Ingredient(name: "Tomato paste", quantity: 1, unit: .tbs),
				Ingredient(name: "Oil", quantity: 1, unit: .tbs)
			],
			directions: [
				Direction(description: "Peel and grate the beets. Dice potatoes into small cubes. Julienne carrot and finely chop onion.", isOptional: false),
				Direction(description: "Heat oil in a skillet over medium heat.", isOptional: false),
				Direction(description: "Sauté onion for 2–3 minutes until translucent.", isOptional: false),
				Direction(description: "Add grated beets and carrot. Cook 5–7 minutes stirring occasionally.", isOptional: false),
				Direction(description: "Stir in tomato paste and cook 1 additional minute to deepen flavor.", isOptional: false),
				Direction(description: "Bring beef broth to a boil in a large pot.", isOptional: false),
				Direction(description: "Add diced potatoes and simmer for 10 minutes.", isOptional: false),
				Direction(description: "Add shredded cabbage and cook 5 minutes.", isOptional: false),
				Direction(description: "Transfer sautéed beet mixture into the soup.", isOptional: false),
				Direction(description: "Simmer gently for 15–20 minutes until vegetables are tender.", isOptional: false),
				Direction(description: "Allow soup to rest 10 minutes before serving to enhance flavor.", isOptional: true)
			]
		),

		// MARK: - French Fries

		Recipe(
			mainInformation: MainInformation(
				name: "French Fries",
				description: "Crispy homemade double-fried fries.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Russet potatoes", quantity: 4, unit: .none),
				Ingredient(name: "Vegetable oil for frying", quantity: 1, unit: .none),
				Ingredient(name: "Salt", quantity: 1, unit: .none)
			],
			directions: [
				Direction(description: "Peel potatoes and cut into even 1 cm thick strips.", isOptional: false),
				Direction(description: "Rinse fries under cold water until water runs clear to remove excess starch.", isOptional: false),
				Direction(description: "Soak in cold water for 30 minutes.", isOptional: false),
				Direction(description: "Drain and thoroughly dry using paper towels.", isOptional: false),
				Direction(description: "Heat oil to 160°C.", isOptional: false),
				Direction(description: "Fry potatoes in batches for 4–5 minutes without browning.", isOptional: false),
				Direction(description: "Remove and rest 10 minutes.", isOptional: false),
				Direction(description: "Increase oil temperature to 190°C.", isOptional: false),
				Direction(description: "Fry again until golden brown and crispy, about 3–4 minutes.", isOptional: false),
				Direction(description: "Drain on rack and season immediately with salt.", isOptional: false)
			]
		),

		// MARK: - Air Fryer Crab Rolls

		Recipe(
			mainInformation: MainInformation(
				name: "Air Fryer Crab Rolls",
				description: "Crispy rice paper rolls filled with crab and cream cheese.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Rice paper sheets", quantity: 6, unit: .none),
				Ingredient(name: "Crab sticks", quantity: 6, unit: .none),
				Ingredient(name: "Cream cheese", quantity: 100, unit: .g),
				Ingredient(name: "Egg (for sealing)", quantity: 1, unit: .none)
			],
			directions: [
				Direction(description: "Prepare a shallow dish with warm water.", isOptional: false),
				Direction(description: "Dip one rice paper sheet for 5–7 seconds until pliable.", isOptional: false),
				Direction(description: "Place softened sheet on clean surface.", isOptional: false),
				Direction(description: "Spread cream cheese across the center.", isOptional: false),
				Direction(description: "Place one crab stick over the cheese.", isOptional: false),
				Direction(description: "Fold sides inward and roll tightly like a spring roll.", isOptional: false),
				Direction(description: "Seal edge with beaten egg.", isOptional: false),
				Direction(description: "Preheat air fryer to 180°C.", isOptional: false),
				Direction(description: "Lightly spray rolls with oil.", isOptional: false),
				Direction(description: "Air fry for 8–10 minutes turning halfway until golden and crisp.", isOptional: false)
			]
		),

		// MARK: - Philadelphia Sushi Rolls

		Recipe(
			mainInformation: MainInformation(
				name: "Philadelphia Sushi Rolls",
				description: "Classic sushi rolls with salmon and cream cheese.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Sushi rice (uncooked)", quantity: 1, unit: .cups),
				Ingredient(name: "Water", quantity: 1, unit: .cups),
				Ingredient(name: "Rice vinegar", quantity: 2, unit: .tbs),
				Ingredient(name: "Nori sheets", quantity: 4, unit: .none),
				Ingredient(name: "Fresh salmon (sushi grade)", quantity: 200, unit: .g),
				Ingredient(name: "Cream cheese", quantity: 100, unit: .g)
			],
			directions: [
				Direction(description: "Rinse sushi rice until water runs clear.", isOptional: false),
				Direction(description: "Cook rice with water, then steam covered 10 minutes off heat.", isOptional: false),
				Direction(description: "Fold rice vinegar into warm rice gently.", isOptional: false),
				Direction(description: "Place nori sheet on bamboo mat.", isOptional: false),
				Direction(description: "Spread thin layer of rice evenly leaving 2 cm border.", isOptional: false),
				Direction(description: "Place salmon strips and cream cheese horizontally.", isOptional: false),
				Direction(description: "Roll tightly using bamboo mat applying even pressure.", isOptional: false),
				Direction(description: "Seal edge with a little water.", isOptional: false),
				Direction(description: "Slice with sharp wet knife into 6–8 pieces.", isOptional: false)
			]
		),

		// MARK: - Cheese Triangle Khachapuri

		Recipe(
			mainInformation: MainInformation(
				name: "Cheese Triangle Khachapuri",
				description: "Crispy puff pastry triangles filled with cheese.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Puff pastry sheet", quantity: 1, unit: .none),
				Ingredient(name: "Tvorog", quantity: 200, unit: .g),
				Ingredient(name: "Mozzarella cheese", quantity: 150, unit: .g),
				Ingredient(name: "Egg (for wash)", quantity: 1, unit: .none)
			],
			directions: [
				Direction(description: "Preheat oven to 180°C.", isOptional: false),
				Direction(description: "Grate mozzarella and mix with tvorog until uniform.", isOptional: false),
				Direction(description: "Roll pastry slightly thinner and cut into squares.", isOptional: false),
				Direction(description: "Place filling in center of each square.", isOptional: false),
				Direction(description: "Fold diagonally to form triangles and seal edges firmly.", isOptional: false),
				Direction(description: "Brush tops with beaten egg.", isOptional: false),
				Direction(description: "Bake 20–25 minutes until puffed and golden brown.", isOptional: false)
			]
		),

		// MARK: - Adjarian Khachapuri

		Recipe(
			mainInformation: MainInformation(
				name: "Adjarian Khachapuri",
				description: "Boat-shaped bread filled with cheese and egg.",
				author: "Youlia",
				category: .dinner
			),
			ingredients: [
				Ingredient(name: "Pizza dough", quantity: 1, unit: .none),
				Ingredient(name: "Mozzarella cheese", quantity: 200, unit: .g),
				Ingredient(name: "Feta cheese", quantity: 100, unit: .g),
				Ingredient(name: "Egg", quantity: 1, unit: .none)
			],
			directions: [
				Direction(description: "Preheat oven to 220°C.", isOptional: false),
				Direction(description: "Roll dough into oval shape.", isOptional: false),
				Direction(description: "Fold edges inward and twist ends to form boat shape.", isOptional: false),
				Direction(description: "Mix cheeses and fill center cavity.", isOptional: false),
				Direction(description: "Bake 12–15 minutes until crust is golden.", isOptional: false),
				Direction(description: "Remove from oven and create small well in center.", isOptional: false),
				Direction(description: "Crack egg into well.", isOptional: false),
				Direction(description: "Return to oven for 3–4 minutes until egg white sets but yolk remains runny.", isOptional: false)
			]
		),

		// MARK: - Baked Milk Buns

		Recipe(
			mainInformation: MainInformation(
				name: "Baked Milk Buns",
				description: "Soft fluffy milk-based yeast buns.",
				author: "Youlia",
				category: .dessert
			),
			ingredients: [
				Ingredient(name: "Flour", quantity: 3, unit: .cups),
				Ingredient(name: "Warm milk", quantity: 1, unit: .cups),
				Ingredient(name: "Sugar", quantity: 3, unit: .tbs),
				Ingredient(name: "Butter (melted)", quantity: 2, unit: .tbs),
				Ingredient(name: "Dry yeast", quantity: 1, unit: .tbs),
				Ingredient(name: "Egg", quantity: 1, unit: .none)
			],
			directions: [
				Direction(description: "Dissolve yeast and sugar in warm milk. Let sit 10 minutes until foamy.", isOptional: false),
				Direction(description: "Mix in melted butter and egg.", isOptional: false),
				Direction(description: "Gradually add flour and knead 8–10 minutes until smooth.", isOptional: false),
				Direction(description: "Place in greased bowl, cover and let rise 1 hour.", isOptional: false),
				Direction(description: "Divide into equal balls and place on baking sheet.", isOptional: false),
				Direction(description: "Let rise additional 30 minutes.", isOptional: false),
				Direction(description: "Bake at 180°C for 18–20 minutes until golden.", isOptional: false)
			]
		),

		// MARK: - Anthill

		Recipe(
			mainInformation: MainInformation(
				name: "Armenian Anthill",
				description: "Traditional Armenian butter-based sweet pastry.",
				author: "Youlia",
				category: .dessert
			),
			ingredients: [
				Ingredient(name: "Flour", quantity: 2, unit: .cups),
				Ingredient(name: "Butter (softened)", quantity: 200, unit: .g),
				Ingredient(name: "Powdered sugar", quantity: 1, unit: .cups),
				Ingredient(name: "Vanilla extract", quantity: 1, unit: .tbs)
			],
			directions: [
				Direction(description: "Cream softened butter and powdered sugar until light and fluffy.", isOptional: false),
				Direction(description: "Mix in vanilla extract.", isOptional: false),
				Direction(description: "Gradually incorporate flour until soft dough forms.", isOptional: false),
				Direction(description: "Chill dough 30 minutes.", isOptional: false),
				Direction(description: "Shape into small rounds or crescents.", isOptional: false),
				Direction(description: "Bake at 170°C for 15–18 minutes until lightly golden.", isOptional: false)
			]
		),

		// MARK: - New Year Pinecone Cookies

		Recipe(
			mainInformation: MainInformation(
				name: "New Year Pinecone Cookies",
				description: "Festive no-bake chocolate pinecone-shaped cookies.",
				author: "Youlia",
				category: .dessert
			),
			ingredients: [
				Ingredient(name: "Chocolate cookies", quantity: 200, unit: .g),
				Ingredient(name: "Cream cheese", quantity: 200, unit: .g),
				Ingredient(name: "Cornflakes", quantity: 2, unit: .cups),
				Ingredient(name: "Powdered sugar (for dusting)", quantity: 1, unit: .tbs)
			],
			directions: [
				Direction(description: "Crush chocolate cookies into fine crumbs.", isOptional: false),
				Direction(description: "Mix crumbs with cream cheese until moldable mixture forms.", isOptional: false),
				Direction(description: "Shape mixture into oval cone shapes.", isOptional: false),
				Direction(description: "Insert cornflakes individually overlapping to resemble pinecone scales.", isOptional: false),
				Direction(description: "Chill 30 minutes to firm up.", isOptional: false),
				Direction(description: "Dust lightly with powdered sugar before serving.", isOptional: false)
			]
		)
	]
}
