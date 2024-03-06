
//  RecipeViewModel.swift
//  Yummy notes
//
//  Created by Knapptan on 21.02.2024.


import Foundation


class RecipeViewModel: ObservableObject {
//    @Published var DBRecipesArray: [RecipeObject] = []
    @Published var hasError: Bool = false
    
    private var recipeDatabase = RecipeDataSource()
    
    // Метод для зугрузки данных с апи
    func getDataFromAPI(endPoint: Character) {
        ApiNetworkManeger.getDataFromAPI(endPoint: String(endPoint)) { result in
            switch result {
            case .success(let decodedData):
                self.convertJSONObject2DBObject(decodedData: decodedData)
            case .failure(let failure):
                self.hasError = true
                _ = failure
            }
        }
    }
    
    // Метод для зугрузки картинки с апи
    func getImageFromAPI(recipe: RecipeObject, imageUrl: URL) {
        ApiNetworkManeger.getImgeFromAPI(imageUrl: imageUrl) { result in
            switch result {
            case .success(let imageData):
                self.recipeDatabase.saveImagetoDatabase(recipe: recipe, imageData: imageData)
                self.notifyObserver()
            case .failure(let error):
                print("Error downloading image:", error.localizedDescription)
            }
        }
    }
 
    // Метод преобразованя данных в объекты для записи в БД
    func convertJSONObject2DBObject(decodedData: [RawRecipe]) {
        for item in decodedData {
            recipeDatabase.saveRecipe(recipe: RecipeObject(item))
        }
        self.notifyObserver()
    }
    
    // Метод получения объектов из БД
    func getRecepiesFromDatabase() -> [RecipeObject] {
        return recipeDatabase.readRecipes()
    }
    
    // Метод отчистки БД
    func cleanDatabase() {
        
        print(recipeDatabase.count)
        
        recipeDatabase.cleanDatabase()
//        self.notifyObserver()
        
        print(recipeDatabase.count)
    }
    
    // Метод обновления объекта рецепта
    func updateRecipe(_ updatedRecipe: RecipeObject, imageData: Data) {
        recipeDatabase.updateRecipe(recipe: updatedRecipe)
        recipeDatabase.updateRecipeImage(recipe: updatedRecipe, imageData: imageData)
        notifyObserver()
    }
    
    // Уведомление SwiftUI о необходимости обновления
    private func notifyObserver() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
