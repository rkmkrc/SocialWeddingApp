//
//  ContentView.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import SwiftUI

struct IntroductionPage: View {
    @ObservedObject var model: ViewModel
    @State var groomImage: UIImage?
    @State var brideImage: UIImage?
    
    var body: some View {
        VStack(alignment: .center) {
            AnimatedText(title: model.wed?.title ?? Constants.DEFAULT_TITLE)
            HStack {
                VStack {
                    Image(uiImage: groomImage ?? UIImage())
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
                    Image(uiImage: brideImage ?? UIImage())
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
            .onAppear() {
                
                
                model.getImageUrlOf(person: "groom") { url, error in
                    if let error = error {
                        print("Error in getting url of Image = \(error)")
                    } else if let url = url {
                        print("Groom's Image URL: \(url)")
                        retrieveImage(withURL: url, completion: { image in
                            if let image = image {
                                self.groomImage = image
                            }
                        })
                    }
                }
                
                model.getImageUrlOf(person: "bride") { url, error in
                    if let error = error {
                        print("Error in getting url of Image = \(error)")
                    } else if let url = url {
                        print("Groom's Image URL: \(url)")
                        retrieveImage(withURL: url, completion: { image in
                            if let image = image {
                                self.brideImage = image
                            }
                        })
                    }
                }
                
                
                
                
            }
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
