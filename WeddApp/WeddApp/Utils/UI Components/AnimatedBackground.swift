//
//  AnimatedBackground.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//

import Foundation
import SwiftUI

struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    var colorSet: Int = 0
    let colorSetList: [[Color]] = [[Color.blue, Color.red, Color.purple, Color.pink, Color.red, Color.purple, Color.blue], [Color.yellow, Color.purple, Color.yellow]]
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
