//
//  HomePage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 9.07.2023.
//

import Foundation
import SwiftUI

struct HomePage: View {
    var body: some View {
        TabView {
            IntroductionPage()
            GalleryPage()
            StoryPage()
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
