//
//  ContentView.swift
//  Yummy notes
//
//  Created by Knapp Tania on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPage = 1
    @State private var currentLetter: Character = "a"
    @ObservedObject var recipeViewModel = RecipeViewModel()
    
    @State private var wasDeleted: Bool = false
    
    var body: some View {
        if recipeViewModel.hasError {
            Text("Произошла ошибка при загрузке данных")
        } else {
                NavigationView {
                    ScrollView {
                        LazyVStack {
//                            Button(action: {
//                                recipeViewModel.cleanDatabase()
//                                
//                                wasDeleted = true
//                            }, label: {
//                                Text("Button")
//                            })
//                            if wasDeleted == false {
                            recipesList
                            progressView
//                        }
                    }
                    .navigationBarTitle("Recipes")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
    
    private var recipesList: some View {
        ForEach(recipeViewModel.getRecepiesFromDatabase(), id: \.id) { recipe in
            NavigationLink(destination: RecipeScreenView(recipe: recipe, model: recipeViewModel)) {
                HStack {
                    RecipeCell(model: recipeViewModel, recipe: recipe)
                    Image(systemName: "chevron.right")
                        .padding(.horizontal)
                }
            }
        }
    }
    
    private var progressView: some View {
        ProgressView()
            .padding(40)
            .onAppear {
                    recipeViewModel.getDataFromAPI(endPoint: currentLetter)
                    let nextLetter = UnicodeScalar(String(currentLetter).unicodeScalars.first!.value + 1)
                    currentLetter = Character(nextLetter!)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
