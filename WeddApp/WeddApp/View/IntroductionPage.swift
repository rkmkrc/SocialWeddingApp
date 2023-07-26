//
//  ContentView.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import SwiftUI

struct IntroductionPage: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            AnimatedText(title: model.wed?.title ?? "")
            HStack {
                VStack {
                    Image(model.wed?.groom.image ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(Constants.imagePadding)
                    Text(model.wed?.groom.name ?? "").font(.title3).fontWeight(.light)
                }
                VStack {
                    Image(model.wed?.bride.image ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(Constants.imagePadding)
                    Text(model.wed?.bride.name ?? "").font(.title3).fontWeight(.light).lineLimit(2)
                }
            }
            Spacer()
            Text(model.wed?.date ?? "").font(.title2).fontWeight(.regular).padding(Constants.textPadding)
            Text(model.wed?.location ?? "   ").font(.title3).fontWeight(.light)
            Spacer()
            Text(model.wed?.welcomeMessage ?? "").font(.title3).fontWeight(.regular).multilineTextAlignment(.center).padding(Constants.textPadding)
            Spacer()
        }.background(AnimatedBackground(colorSet: 0).blur(radius: 190))
            .padding(.top, Constants.topPadding)
    }
    init(model: ViewModel) {
        self.model = model
    }
}
/*
struct IntroductionPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionPage()
    }
}
*/
