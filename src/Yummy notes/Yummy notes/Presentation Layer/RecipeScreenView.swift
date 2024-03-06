//
//  RecipeScreenView.swift
//  Yummy notes
//
//  Created by Anton Krivonozhenkov on 29.01.2024.

import SwiftUI

struct RecipeScreenView: View {
    var recipe: RecipeObject
    @ObservedObject var model: RecipeViewModel
    @State private var selectedTab: Int = 0
    @State private var recipeSteps: [String] = []
    
    init(recipe: RecipeObject, model: RecipeViewModel) {
        self.recipe = recipe
        self.model = model
    }
    
    var body: some View {
        ScrollView {
            VStack {
                RecipeCell(model: model, recipe: recipe)
                
                GroupBox {
                    DisclosureGroup ("Ingridients") {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .font(.callout)
                        }
                    }
                }
                .padding(.bottom)
                .onAppear {
                    recipeSteps = recipe.steps.components(separatedBy: "\n").filter { $0 != "\r" }
                }
                
                TabView(selection: $selectedTab) {
                    ForEach(0..<recipeSteps.count, id: \.self) { index in
                        VStack {
                            Text("Step \(index + 1) of \(recipeSteps.count)\n\n" + recipeSteps[index])
                                .lineLimit(nil)
                                .padding(.horizontal, 5)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if index < recipeSteps.count - 1 {
                                Button { withAnimation { selectedTab = index + 1 } } label: { Text("Next step") }
                            }
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(minHeight: 500, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle(recipe.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Edit") {
                        RecipeEditorView(recipe: recipe, model: model)
                    }
                }
            }
            
        }
    }
}
