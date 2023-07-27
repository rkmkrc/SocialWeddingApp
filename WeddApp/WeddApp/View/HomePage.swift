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
    var pin: String

    var body: some View {
        if model.wed == nil {
            // Placeholder view or loading indicator while waiting for data
            Text("Loading...").font(.title2).fontWeight(.bold)
        } else {
            TabView {
                IntroductionPage(model: model) // Pass the model to IntroductionPage
                GalleryPage()
                StoryPage()
            }
            .navigationTitle(pin)
            .tabViewStyle(PageTabViewStyle())
            //.navigationBarBackButtonHidden(true)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
            .edgesIgnoringSafeArea(.all)
        }
    }

    init(pin: String) {
        print("----------------------------------- Home \(pin) -----------------------------------")
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
