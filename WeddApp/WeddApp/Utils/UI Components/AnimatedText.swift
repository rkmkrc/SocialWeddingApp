//
//  AnimatedText.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//

import Foundation
import SwiftUI

struct AnimatedText: View {
    
    @State private var counter: Int = 0
    @State private var rotation: Double = 0
    @State private var isSliding: Bool = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var title: String
    var letters: [Character] {
        Array(title)
    }
    let slideGently = Animation.easeOut(duration: 1).delay(2).repeatForever(autoreverses: false).delay(-0.67)
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<letters.count, id: \.self) { slide in
                Text(String(letters[slide]))
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .scaleEffect(isSliding ? 0.25 : 1)
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: -1, z: 0))
                    .opacity(isSliding ? 0 : 1)
                    .hueRotation(.degrees(isSliding ? 320 : 0))
                    .animation(.easeOut(duration: 1).delay(2).repeatForever(autoreverses: false).delay(Double(-slide) / 20), value: isSliding)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
        .onAppear {
            isSliding = true
            rotation = 360
        }
    }
}


struct AnimatedText_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedText(title: TestModels.wedding.title)
            .preferredColorScheme(.dark)
    }
}
