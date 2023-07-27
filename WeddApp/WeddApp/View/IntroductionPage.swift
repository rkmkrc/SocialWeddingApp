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
            AnimatedText(title: model.wed?.title ?? Constants.DEFAULT_TITLE)
            HStack {
                VStack {
                    Image(model.wed?.groom?.image ?? Constants.PLACEHOLDER_GROOM_IMAGE)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(Constants.IMAGE_PADDING)
                    Text(model.wed?.groom?.name ?? Constants.DEFAULT_NAME).font(.title3).fontWeight(.light)
                }
                VStack {
                    Image(model.wed?.bride?.image ?? Constants.PLACEHOLDER_BRIDE_IMAGE)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(Constants.IMAGE_PADDING)
                    Text(model.wed?.bride?.name ?? Constants.DEFAULT_NAME).font(.title3).fontWeight(.light).lineLimit(2)
                }
            }
            Spacer()
            Text(model.wed?.date ?? Constants.DEFAULT_DATE).font(.title2).fontWeight(.regular).padding(Constants.TEXT_PADDING)
            Text(model.wed?.location ?? Constants.DEFAULT_LOCATION).font(.title3).fontWeight(.light)
            Spacer()
            Text(model.wed?.welcomeMessage ?? Constants.DEFAULT_WELCOME_MESSAGE).font(.title3).fontWeight(.regular).multilineTextAlignment(.center).padding(Constants.TEXT_PADDING)
            Spacer()
        }.background(AnimatedBackground(colorSet: 0).blur(radius: 190))
            .padding(.top, Constants.TOP_PADDING)
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
