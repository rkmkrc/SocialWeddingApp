//
//  Utilities.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import Foundation
import SwiftUI

struct SlideWith3DYRotation: View {
    
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


struct SlideWith3DYRotation_Previews: PreviewProvider {
    static var previews: some View {
        SlideWith3DYRotation(title: TestModels.wedding.title)
            .preferredColorScheme(.dark)
    }
}

struct AnimatedBackground: View {
    var colorSet: Int = 0
    let colorSetList: [[Color]] = [[Color.blue, Color.red, Color.purple, Color.pink, Color.red, Color.purple, Color.blue], [Color.yellow, Color.purple, Color.yellow]]
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    var colors: [Color] {
        colorSetList[colorSet]
        }
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .onReceive(timer, perform: { _ in
                withAnimation(Animation.easeInOut(duration: 2).repeatForever()) {
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                    self.start = UnitPoint(x: -4, y: 20)
                    self.start = UnitPoint(x: 4, y: 0)
                }
            })
    }
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground(colorSet: 0)
            .ignoresSafeArea()
            .blur(radius: 100)
    }
}
