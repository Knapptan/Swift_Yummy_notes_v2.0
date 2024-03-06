//
//  RealmData.swift
//  Yummy notes
//
//  Created by Knapp Tania on 1/29/24.
//
import Foundation
import Alamofire
import RealmSwift

class RecipeDataSource: ObservableObject {
    @Published var realm: Realm?
//    @Published var savedRecipes: [RecipeObject] = []
    
    @Published var count: Int = 0
    
    init() {
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            print("Error initializing Realm:", error.localizedDescription)
        }
    }
    
    func saveRecipe(recipe: RecipeObject) {
        do {
            try realm?.write {
                realm?.add(recipe, update: .modified)
                count += 1
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Удаление рецепта
    func deleteRecipe(recipe: RawRecipe) {
        do {
            // Находим объект типа RecipeObject по id в базе данных
            if let recipeObject = realm?.object(ofType: RecipeObject.self, forPrimaryKey: recipe.idMeal) {
                try realm?.write {
                    // Удаляем найденный объект из базы данных
                    realm?.delete(recipeObject)
                    count -= 1
                }
            } else {
                // Если объект не найден, выводим сообщение об ошибке
                print("RecipeObject not found for id:", recipe.idMeal)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Обновление рецепта 
    func updateRecipe(recipe: RecipeObject) {
        do {
            try realm?.write {
                realm?.add(recipe, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateRecipeImage(recipe: RecipeObject, imageData: Data) {
        do {
            let realm = try Realm()
            try realm.write {
                recipe.imageData = imageData
            }
        } catch {
            print("Error updating image data:", error.localizedDescription)
        }
    }
    
    // Метод для чтения всех рецептов из базы данных
    func readRecipes() -> [RecipeObject] {
        // Проверяем, что realm не равно nil
        guard let realm = realm else { return [] }
        
        // Получаем все объекты типа RecipeObject из базы данных
        let recipes = realm.objects(RecipeObject.self)
        
        // Преобразуем результат в массив и возвращаем его
        return Array(recipes)
    }
    
    func cleanDatabase()  {
        do {
            try realm?.write {
                    realm?.deleteAll()
                }
            } catch {
                print(error.localizedDescription)
            }
        
        count = 0
        
        }
    
    func saveImagetoDatabase(recipe: RecipeObject, imageData: Data) {
        do {
            let realm = try Realm()
            try realm.write {
                recipe.imageData = imageData
            }
        } catch {
            print("Error saving image data:", error.localizedDescription)
        }
    }
}

class RecipeObject: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String = ""
    @Persisted var imageName: String = ""
    @Persisted var imageData: Data? // Данные изображения
    @Persisted var steps: String = ""
    @Persisted var ingredients: List<String> // Используем тип List<String> для хранения списка
    
    convenience init(_ recipe: RawRecipe) {
        self.init()
        id = recipe.idMeal
        name = recipe.strMeal
        steps = recipe.strInstructions
        imageName = recipe.strMealThumb
        // Добавляем каждый ингредиент в список ingredients
        let allIngredients = recipe.ingredients()
        for ingredient in allIngredients {
            if !ingredient.isEmpty {
                ingredients.append(ingredient)
            }
        }
    }
    
    convenience init(id: String, name: String, imageName: String, imageData: Data?, steps: String, ingredients: [String]) {
        self.init()
        self.id = id
        self.name = name
        self.steps = steps
        self.imageName = imageName
        self.imageData = imageData
        // Добавляем каждый ингредиент в список ingredients
        for ingredient in ingredients {
            if !ingredient.isEmpty {
                self.ingredients.append(ingredient)
            }
        }
    }
}
