// Models the application


import Foundation

// Main structure of recipe
struct Recipe: Identifiable {
    var id = UUID()
    var mainInformation: MainInformation
    var ingredients: [Ingredient]
    var directions: [Direction]
    
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
    
    // Enumeration that holds all the possible categories with String raw values
    enum Category: String, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case dessert = "Dessert"
    }
}

// Separate structs for ingredients and drections as type of [String] won't let us store additional information with each ingredient or direction
struct Ingredient {
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
    
    
    
}

struct Direction {
    var description: String
    var isOptional: Bool // Adding nuts to a cookie might be optional, so this property will let us present that information to the user
}

extension Recipe {
  static let testRecipes: [Recipe] = [

    Recipe(mainInformation: MainInformation(
              name: "High-Protein Chicken Salad",
              description: "Light, high-protein salad with fresh vegetables.",
              author: "Youlia",
              category: .lunch),
           ingredients: [
              Ingredient(name: "Grilled chicken breast", quantity: 2, unit: .none),
              Ingredient(name: "Cherry tomatoes", quantity: 5, unit: .cups),
              Ingredient(name: "Cucumber", quantity: 3, unit: .none),
              Ingredient(name: "Avocado", quantity: 1, unit: .none),
              Ingredient(name: "Olive oil", quantity: 1, unit: .tbs),
              Ingredient(name: "Lemon juice", quantity: 1, unit: .tbs)
           ],
           directions: [
              Direction(description: "Chop all vegetables into bite-sized pieces.", isOptional: false),
              Direction(description: "Slice grilled chicken.", isOptional: false),
              Direction(description: "Combine all ingredients in a bowl.", isOptional: false),
              Direction(description: "Drizzle with olive oil and lemon juice.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Warm Mushroom Salad",
              description: "Savory mushroom salad with garlic and herbs.",
              author: "Youlia",
              category: .lunch),
           ingredients: [
              Ingredient(name: "Mushrooms", quantity: 300, unit: .g),
              Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
              Ingredient(name: "Fresh parsley", quantity: 1, unit: .tbs),
              Ingredient(name: "Salt", quantity: 1, unit: .none)
           ],
           directions: [
              Direction(description: "Slice mushrooms.", isOptional: false),
              Direction(description: "Saute mushrooms in olive oil until golden.", isOptional: false),
              Direction(description: "Season with salt and fresh parsley.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Armenian Yogurt Soup (Spas)",
              description: "Traditional Armenian soup with matsun, egg, flour and greens.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Matsun (plain yogurt)", quantity: 500, unit: .g),
              Ingredient(name: "Sour cream", quantity: 2, unit: .tbs),
              Ingredient(name: "Egg", quantity: 1, unit: .none),
              Ingredient(name: "Flour", quantity: 2, unit: .tbs),
              Ingredient(name: "Water", quantity: 3, unit: .cups),
              Ingredient(name: "Fresh greens", quantity: 1, unit: .cups)
           ],
           directions: [
              Direction(description: "Whisk yogurt, sour cream, egg and flour until smooth.", isOptional: false),
              Direction(description: "Add water and cook on low heat, stirring constantly.", isOptional: false),
              Direction(description: "Cook until slightly thickened.", isOptional: false),
              Direction(description: "Add chopped greens and simmer 5 minutes.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Crispy Fried Chicken",
              description: "Homemade KFC-style crispy chicken.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Chicken pieces", quantity: 1, unit: .none),
              Ingredient(name: "Flour", quantity: 2, unit: .cups),
              Ingredient(name: "Eggs", quantity: 2, unit: .none),
              Ingredient(name: "Paprika", quantity: 1, unit: .tbs),
              Ingredient(name: "Salt", quantity: 1, unit: .tbs)
           ],
           directions: [
              Direction(description: "Season chicken.", isOptional: false),
              Direction(description: "Dip in egg mixture.", isOptional: false),
              Direction(description: "Coat with seasoned flour.", isOptional: false),
              Direction(description: "Deep fry until golden and crispy.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Russian Borscht",
              description: "Traditional beet soup with vegetables.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Beets", quantity: 2, unit: .none),
              Ingredient(name: "Potatoes", quantity: 2, unit: .none),
              Ingredient(name: "Carrot", quantity: 1, unit: .none),
              Ingredient(name: "Cabbage", quantity: 1, unit: .cups),
              Ingredient(name: "Beef broth", quantity: 4, unit: .cups)
           ],
           directions: [
              Direction(description: "Boil broth.", isOptional: false),
              Direction(description: "Add chopped vegetables.", isOptional: false),
              Direction(description: "Simmer 40 minutes.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "French Fries",
              description: "Crispy homemade fries.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Potatoes", quantity: 4, unit: .none),
              Ingredient(name: "Oil for frying", quantity: 1, unit: .none),
              Ingredient(name: "Salt", quantity: 1, unit: .none)
           ],
           directions: [
              Direction(description: "Cut potatoes into strips.", isOptional: false),
              Direction(description: "Fry until golden.", isOptional: false),
              Direction(description: "Season with salt.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Air Fryer Crab Rolls",
              description: "Crispy rice paper rolls with crab sticks.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Rice paper sheets", quantity: 6, unit: .none),
              Ingredient(name: "Crab sticks", quantity: 6, unit: .none),
              Ingredient(name: "Cream cheese", quantity: 3, unit: .tbs)
           ],
           directions: [
              Direction(description: "Soften rice paper in water.", isOptional: false),
              Direction(description: "Add filling and roll tightly.", isOptional: false),
              Direction(description: "Air fry at 180C for 10 minutes.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Philadelphia Sushi Rolls",
              description: "Classic sushi rolls with salmon and cream cheese.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Sushi rice", quantity: 2, unit: .cups),
              Ingredient(name: "Nori sheets", quantity: 4, unit: .none),
              Ingredient(name: "Salmon", quantity: 200, unit: .g),
              Ingredient(name: "Cream cheese", quantity: 100, unit: .g)
           ],
           directions: [
              Direction(description: "Spread rice over nori.", isOptional: false),
              Direction(description: "Add salmon and cream cheese.", isOptional: false),
              Direction(description: "Roll tightly and slice.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Cheese Triangle Khachapuri",
              description: "Baked triangular pastry filled with cheese and tvorog.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Puff pastry", quantity: 1, unit: .none),
              Ingredient(name: "Tvorog", quantity: 200, unit: .g),
              Ingredient(name: "Cheese", quantity: 150, unit: .g),
              Ingredient(name: "Egg", quantity: 1, unit: .none)
           ],
           directions: [
              Direction(description: "Mix cheese and tvorog.", isOptional: false),
              Direction(description: "Fill pastry and shape triangles.", isOptional: false),
              Direction(description: "Brush with egg.", isOptional: false),
              Direction(description: "Bake at 180C until golden.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Adjarian Khachapuri",
              description: "Boat-shaped bread filled with cheese and egg.",
              author: "Youlia",
              category: .dinner),
           ingredients: [
              Ingredient(name: "Dough", quantity: 1, unit: .none),
              Ingredient(name: "Cheese", quantity: 250, unit: .g),
              Ingredient(name: "Egg", quantity: 1, unit: .none)
           ],
           directions: [
              Direction(description: "Shape dough into boat.", isOptional: false),
              Direction(description: "Fill with cheese and bake.", isOptional: false),
              Direction(description: "Add egg on top and bake briefly.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Baked Milk Buns",
              description: "Soft oven-baked buns served with milk.",
              author: "Youlia",
              category: .dessert),
           ingredients: [
              Ingredient(name: "Flour", quantity: 3, unit: .cups),
              Ingredient(name: "Milk", quantity: 1, unit: .cups),
              Ingredient(name: "Sugar", quantity: 3, unit: .tbs),
              Ingredient(name: "Butter", quantity: 2, unit: .tbs),
              Ingredient(name: "Yeast", quantity: 1, unit: .tbs)
           ],
           directions: [
              Direction(description: "Mix ingredients and knead dough.", isOptional: false),
              Direction(description: "Let rise for 1 hour.", isOptional: false),
              Direction(description: "Shape buns and bake at 180C.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "Armenian Mrjnabuyn",
              description: "Traditional Armenian sweet pastry.",
              author: "Youlia",
              category: .dessert),
           ingredients: [
              Ingredient(name: "Flour", quantity: 2, unit: .cups),
              Ingredient(name: "Butter", quantity: 200, unit: .g),
              Ingredient(name: "Sugar", quantity: 1, unit: .cups)
           ],
           directions: [
              Direction(description: "Mix ingredients into dough.", isOptional: false),
              Direction(description: "Shape and bake until golden.", isOptional: false)
           ]),

    Recipe(mainInformation: MainInformation(
              name: "New Year Pinecone Cookies",
              description: "Festive chocolate pinecone-shaped cookies.",
              author: "Youlia",
              category: .dessert),
           ingredients: [
              Ingredient(name: "Chocolate cookies", quantity: 10, unit: .none),
              Ingredient(name: "Cream cheese", quantity: 200, unit: .g),
              Ingredient(name: "Cornflakes", quantity: 1, unit: .cups)
           ],
           directions: [
              Direction(description: "Crush cookies and mix with cream cheese.", isOptional: false),
              Direction(description: "Shape into cones.", isOptional: false),
              Direction(description: "Decorate with cornflakes.", isOptional: false)
           ])
  ]
}
