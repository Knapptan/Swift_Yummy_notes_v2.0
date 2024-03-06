//
//  RecipeEditorView.swift
//  Yummy notes
//
//  Created by Anton Krivonozhenkov on 27.02.2024.
//

import SwiftUI
import PhotosUI

struct RecipeEditorView: View {
    var recipe: RecipeObject
    @ObservedObject var model: RecipeViewModel
    
    @State private var title: String = ""
    @State private var recipeIngredients: [String] = []
    @State private var recipeSteps: [String] = []
    
    @State private var imageDB = UIImage(systemName: "star")!
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    var body: some View {
        ScrollView {
            VStack {
                Text("Change title")
                TextField("", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Change ingridients")
                    .padding(.top)
                ForEach(0..<recipeIngredients.count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)")
                        TextField("", text: $recipeIngredients[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                Text("Change image")
                    .padding(.top)
                
                Image(uiImage: imageDB)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .overlay {  Circle().stroke(.gray, lineWidth: 2) }
                    .overlay(alignment: .bottomTrailing) {
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .all(of: [.images])
                        ) {
                            Image(systemName: "pencil.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 30))
                                .foregroundColor(.accentColor)
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedPhotoData = data
                                    
                                    if let selectedPhotoData {
                                        imageDB = UIImage(data: selectedPhotoData)!
                                    }
                                }
                            }
                        }
                    }
                
                Text("Change steps")
                    .padding(.top)
                ForEach(0..<recipeSteps.count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)")
                        TextField("", text: $recipeSteps[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .padding()
            .onAppear(perform: {
                title = recipe.name
                recipeSteps = recipe.steps.components(separatedBy: "\n").filter { $0 != "\r" }
                for ingridient in recipe.ingredients {
                    recipeIngredients.append(ingridient)
                }
                if let imageData = recipe.imageData {
                    imageDB = UIImage(data: imageData)!
                }
            })
        }
        .navigationTitle("Local Recipe Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { withAnimation() { saveChanges() }
                }) { Text("Save") }
            }
        }
    }
    
    func saveChanges() {
        var steps: String = ""
        
        for (index, element) in recipeSteps.enumerated() {
            if index < recipeSteps.count - 1 {
                steps = steps + element + "\n"
            } else {
                steps = steps + element
            }
        }

        if selectedPhotoData == nil { selectedPhotoData = recipe.imageData }
        let changedRecipe = RecipeObject(id: recipe.id,
                                         name: title,
                                         imageName: recipe.imageName,
                                         imageData: selectedPhotoData,
                                         steps: steps,
                                         ingredients: recipeIngredients)
        model.updateRecipe(changedRecipe, imageData: selectedPhotoData!)
    }
}
