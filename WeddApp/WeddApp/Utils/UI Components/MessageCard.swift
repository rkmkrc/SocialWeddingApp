//
//  MessageCard.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//

import Foundation
import SwiftUI

struct MessageCard: View {
    let username: String
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.title)
                Text(username)
                    .font(.headline)
                Spacer()
            }
            
            Text(message)
                .font(.body)
                .lineLimit(nil)
            
            Divider()
            
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "heart")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

struct MessageCard_Previews: PreviewProvider {
    static var previews: some View {
        MessageCard(username: "Marry", message: "Congratulations. I wish all my best..")
            .ignoresSafeArea()
    }
}
