//
//  HomePage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 9.07.2023.
//

import Foundation
import SwiftUI

struct HomePage: View {
    var pin: String = ""
    var body: some View {
        TabView {
            IntroductionPage()
            GalleryPage()
            StoryPage()
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationBarBackButtonHidden(true)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage().edgesIgnoringSafeArea(.all)
    }
}
