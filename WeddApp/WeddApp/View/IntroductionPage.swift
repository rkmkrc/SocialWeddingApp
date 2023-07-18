//
//  ContentView.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import SwiftUI
import CoreData

struct IntroductionPage: View {
    var groom = TestModels.groom
    var bride = TestModels.bride
    
    var body: some View {
        VStack(alignment: .center) {
            AnimatedText(title: TestModels.wedding.title)
            HStack {
                VStack {
                    Image(groom.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(Constants.imagePadding)
                    Text(groom.name).font(.title3).fontWeight(.light)
                }
                VStack {
                    Image(bride.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(Constants.imagePadding)
                    Text(bride.name).font(.title3).fontWeight(.light).lineLimit(2)
                }
            }
            Spacer()
            Text(TestModels.wedding.date).font(.title2).fontWeight(.regular).padding(Constants.textPadding)
            Text(TestModels.wedding.location).font(.title3).fontWeight(.light)
            Spacer()
            Text(TestModels.wedding.welcomeMessage).font(.title3).fontWeight(.regular).multilineTextAlignment(.center).padding(Constants.textPadding)
            Spacer()
        }.background(AnimatedBackground(colorSet: 0).ignoresSafeArea().blur(radius: 190))
    }
}

struct IntroductionPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
