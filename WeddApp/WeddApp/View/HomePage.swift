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
    var pin: String // The pin is now a parameter for the HomePage

    var body: some View {
        TabView {
            IntroductionPage(model: model) // Pass the pin to the IntroductionPage
            GalleryPage()
            StoryPage()
        }
        .navigationTitle(pin)
        .tabViewStyle(PageTabViewStyle())
        .navigationBarBackButtonHidden(true)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
        .edgesIgnoringSafeArea(.all)
    }

    init(pin: String) {
        self.pin = pin
        self.model = ViewModel(id: "60") // Pass the pin to initialize the ViewModel
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
