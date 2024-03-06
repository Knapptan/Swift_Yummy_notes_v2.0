//
//  RecipeRow.swift
//  Yummy notes
//
//  Created by Knapptan on 18.02.2024.

import SwiftUI
import RealmSwift
import Realm

struct RecipeCell: View {
    @State private var imageDataLoaded = false
    @ObservedObject var model: RecipeViewModel
    var recipe: RecipeObject
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.gray, lineWidth: 2)
                            }
                            .padding()
                    } else {
                        if !imageDataLoaded {
                            ProgressView()
                                .padding(40)
                        } else {
                            Text("No image available")
                                .padding()
                        }
                    }
                }
                .onAppear {
                    if recipe.imageData == nil, let imageUrl = URL(string: recipe.imageName) {
                        model.getImageFromAPI(recipe: recipe, imageUrl: imageUrl)
                    }
                }
                
                Text(recipe.name)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.leading)
                
                Spacer()
            }
            Divider()
        }
    }
}
