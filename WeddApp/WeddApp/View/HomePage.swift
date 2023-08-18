//
//  HomePage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 9.07.2023.
//

import Foundation
import SwiftUI

struct HomePage: View {
    @ObservedObject var model: ViewModel
    @State private var addWishButtonTapped: Bool = false
    var pin: String
    
    var body: some View {
        NavigationStack {
            if model.wed == nil {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                TabView {
                    IntroductionPage(model: model)
                    GalleryPage(model: model)
                    StoryPage(model: model, addWishButtonTapped: $addWishButtonTapped)
                    
                }
                .tabViewStyle(PageTabViewStyle())
                .navigationBarBackButtonHidden()
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                .edgesIgnoringSafeArea(.all)
            }
            NavigationLink(destination: WishPage(model: model, addWishButtonTapped: $addWishButtonTapped), isActive: $addWishButtonTapped) { EmptyView() }
        }
    }
    
    init(pin: String) {
        self.pin = pin
        self.model = ViewModel(id: pin) // Pass the pin to initialize the ViewModel
        self.model.getWedding() // Fetch the wedding data
    }
}

/*
 struct HomePage_Previews: PreviewProvider {
 static var previews: some View {
 HomePage().edgesIgnoringSafeArea(.all)
 }
 }
 */
