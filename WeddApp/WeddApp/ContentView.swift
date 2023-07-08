//
//  ContentView.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import SwiftUI
import CoreData



struct ContentView: View {
    var groom = TestModels.groom
    var bride = TestModels.bride
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Ali & Fatma")
                .font(.largeTitle)
                .fontWeight(.semibold).padding(10)
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
                    .padding(10)
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
                    .padding(10)
                    Text(bride.name).font(.title3).fontWeight(.light).lineLimit(2)
                }
            }
            Spacer()
            Text(TestModels.wedding.date).font(.title2).fontWeight(.light).padding(10)
            Text(TestModels.wedding.location).font(.title3).fontWeight(.light)
            Spacer()
            Text(TestModels.wedding.welcomeMessage).font(.title3).fontWeight(.light).multilineTextAlignment(.center).padding(20)
            Spacer()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
