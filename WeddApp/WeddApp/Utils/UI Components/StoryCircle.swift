//
//  StoryCircle.swift
//  WeddApp
//
//  Created by Erkam Karaca on 18.07.2023.
//

import Foundation
import SwiftUI

struct StoryCircle: View {
    let imageName: String
    let username: String
    
    @State private var isImageZoomed = false
    @State private var timerProgress: CGFloat = 1.0
    @State private var timerDuration: TimeInterval = 2.0
    @State private var timer: Timer?
    @State private var isStoryOpened = false
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(LinearGradient(gradient: isStoryOpened ? Gradient(colors: [Color.gray]) : Gradient(colors: [Color.red, Color.orange, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                        .rotationEffect(.degrees(-90))
                )
                .onTapGesture {
                    resetTimer()
                    startTimer()
                    isImageZoomed.toggle()
                    isStoryOpened = true
                }
                .fullScreenCover(isPresented: $isImageZoomed) {
                    ZStack {
                        VStack {
                            ZStack {
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                                        .frame(width: geometry.size.width * (1.1 - timerProgress), height: 2)
                                }
                                .padding(.all, 20)
                                
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                            }
                            Spacer()
                        }
                        .onAppear {
                            resetTimer()
                        }
                        .onDisappear {
                            resetTimer()
                            timer?.invalidate() // Cancel the scheduled timer
                        }
                    }
                }
            Text(username)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            withAnimation(.linear(duration: timerDuration)) {
                timerProgress -= 0.01 / CGFloat(timerDuration)
                if timerProgress <= 0.0 {
                    isImageZoomed = false
                    timer?.invalidate() // Cancel the scheduled timer
                }
            }
        }
    }
    
    private func resetTimer() {
        timerProgress = 1.0
    }
}


struct StoryCirclesView: View {
    let stories: [Story]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(stories, id: \.id) { story in
                    StoryCircle(imageName: story.imageName, username: story.username)
                }
            }
            .padding(.all)
        }
    }
}

struct Story: Identifiable {
    let id = UUID()
    let imageName: String
    let username: String
}
