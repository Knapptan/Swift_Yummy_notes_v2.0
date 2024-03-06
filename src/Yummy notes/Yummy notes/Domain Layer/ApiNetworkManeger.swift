//
//  ApiNetworkManeger.swift
//  Yummy notes
//
//  Created by Knapptan on 18.02.2024.
//

import Foundation
import Alamofire

class ApiNetworkManeger{
    static let baseUrl = "https://themealdb.com/api/json/v1/1/search.php?f="
    
    static func getDataFromAPI(endPoint: String,
                               
                               completion: @escaping (Result<[RawRecipe], Error>) -> Void) {
        
        
        AF.request(
            baseUrl + endPoint,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            interceptor: nil
        ).responseDecodable(of: RawRecipes.self) { response in
            switch response.result {
            case .success(let decodedData):
                completion(.success(decodedData.meals))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Метод для запроса картинок по URL
    static func getImgeFromAPI(imageUrl: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(imageUrl).responseData { responseData in
            switch responseData.result {
            case .success(let value):
                completion(.success(value)) // Возвращаем данные изображения в случае успеха
            case .failure(let error):
                completion(.failure(error)) // Возвращаем ошибку в случае неудачи
            }
        }
    }
}

// Структура для декода ответа с API для DTO
struct RawRecipe: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    //    let strIngredient16: String?
    //    let strIngredient17: String?
    //    let strIngredient18: String?
    //    let strIngredient19: String?
    //    let strIngredient20: String?
    
    // Coding case для обработки нулл
    // Можно перенастроить
    
    // Опциональный инициализатор
    init(idMeal: String, strMeal: String, strMealThumb: String, strInstructions: String, ingredients: [String?]) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.strInstructions = strInstructions
        
        // Присвоение опциональных типов данных свойствам ingredients
        self.strIngredient1 = nil
        self.strIngredient2 = nil
        self.strIngredient3 = nil
        self.strIngredient4 = nil
        self.strIngredient5 = nil
        self.strIngredient6 = nil
        self.strIngredient7 = nil
        self.strIngredient8 = nil
        self.strIngredient9 = nil
        self.strIngredient10 = nil
        self.strIngredient11 = nil
        self.strIngredient12 = nil
        self.strIngredient13 = nil
        self.strIngredient14 = nil
        self.strIngredient15 = nil
        //        self.strIngredient16 = nil
        //        self.strIngredient17 = nil
        //        self.strIngredient18 = nil
        //        self.strIngredient19 = nil
        //        self.strIngredient20 = nil
    }
    
    // Метод для получения массива ингредиентов
    func ingredients() -> [String] {
        var ingredients: [String] = []
        if let ingredient1 = strIngredient1 { ingredients.append(ingredient1) }
        if let ingredient2 = strIngredient2 { ingredients.append(ingredient2) }
        if let ingredient3 = strIngredient3 { ingredients.append(ingredient3) }
        if let ingredient4 = strIngredient4 { ingredients.append(ingredient4) }
        if let ingredient5 = strIngredient5 { ingredients.append(ingredient5) }
        if let ingredient6 = strIngredient6 { ingredients.append(ingredient6) }
        if let ingredient7 = strIngredient7 { ingredients.append(ingredient7) }
        if let ingredient8 = strIngredient8 { ingredients.append(ingredient8) }
        if let ingredient9 = strIngredient9 { ingredients.append(ingredient9) }
        if let ingredient10 = strIngredient10 { ingredients.append(ingredient10) }
        if let ingredient11 = strIngredient11 { ingredients.append(ingredient11) }
        if let ingredient12 = strIngredient12 { ingredients.append(ingredient12) }
        if let ingredient13 = strIngredient13 { ingredients.append(ingredient13) }
        if let ingredient14 = strIngredient14 { ingredients.append(ingredient14) }
        if let ingredient15 = strIngredient15 { ingredients.append(ingredient15) }
        return ingredients
    }
}

// Структура для хранения необработанных данных о рецептах из API
struct RawRecipes: Codable {
    let meals: [RawRecipe]
}
