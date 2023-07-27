//
//  StoryPage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//
import SwiftUI

struct StoryPage: View {
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
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<10) { index in
                        MessageCard(username: "Marry", message: "Congratulations. I wish you all the best..")
                    }
                }
                .padding()
            }
        }.background(AnimatedBackground(colorSet: 1).blur(radius: 190))
            .padding(.top, Constants.TOP_PADDING)
    }
}

struct StoryPages_Previews: PreviewProvider {
    static var previews: some View {
        StoryPage()
    }
}


