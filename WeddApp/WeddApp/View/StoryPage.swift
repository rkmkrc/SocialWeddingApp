//
//  StoryPage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//
import SwiftUI

struct StoryPage: View {
    @ObservedObject var model: ViewModel
    @Binding var addWishButtonTapped: Bool
    @State var wishes: [Wish]?
    
    let stories: [Story] = [
        Story(imageName: "bride", username: "user1"),
        Story(imageName: "groom", username: "user2"),
        Story(imageName: "p1", username: "user3"),
        Story(imageName: "bride", username: "user1"),
        Story(imageName: "groom", username: "user2"),
        Story(imageName: "p1", username: "user3")
    ]
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                StoryCirclesView(stories: stories)
            }
            Spacer()
            ZStack {
                if let wishes = wishes {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(wishes) { wish in
                                MessageCard(username: wish.guestName, message: wish.wish)
                            }
                        }
                        .padding()
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            print("TAPP")
                            addWishButtonTapped = true
                        }) {
                            Image(systemName: "plus.message.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(AnimatedBackground(colorSet: 1))
                        .clipShape(Circle())
                        .padding(.all, 30)
                    }
                }
            }
            
        }.background(AnimatedBackground(colorSet: 1).blur(radius: 190))
            .padding(.top, Constants.TOP_PADDING)
            .onAppear() {
                model.getWishes { wishes, error in
                    if let error = error {
                        processWeddingError(error: WeddingError.gettingWishesError(error.localizedDescription))
                    } else {
                        self.wishes = wishes
                    }
                }
            }
    }
}
/*
struct StoryPages_Previews: PreviewProvider {
    static var previews: some View {
        StoryPage()
    }
}
*/

