//
//  GalleryPage.swift
//  WeddApp
//
//  Created by Erkam Karaca on 9.07.2023.
//

import SwiftUI

struct Photo: Identifiable {
    let id = UUID()
    let photo: UIImage
}

struct GalleryPage: View {
    @ObservedObject var model: ViewModel
    @State var galleryUrls: [String] = []
    @State var photos: [Photo] = []
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var selectedPhoto: Photo? = nil // Track the selected photo
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                Spacer()
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(photos) { photo in
                            GeometryReader { geometry in
                                Image(uiImage: photo.photo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.width * 1)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedPhoto = photo // Set the selected photo
                                        }
                                    }
                            }
                            .aspectRatio(contentMode: .fit)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            Spacer()
        }
        .background(AnimatedBackground(colorSet: 1).blur(radius: 190))
        .padding(.top, Constants.TOP_PADDING)
        .fullScreenCover(item: $selectedPhoto) { photo in
            GalleryFullScreenView(photo: photo, isPresented: $selectedPhoto)
        }.onAppear() {
            if photos.isEmpty {
                self.model.retrieveGallery() { uiImages in
                    // Transform UIImage? array to Photo array
                    let photoArray = uiImages.map { uiImage in
                        Photo(photo: uiImage ?? UIImage())
                    }
                    self.photos = photoArray
                }
            }
        }
    }
}

struct GalleryFullScreenView: View {
    let photo: Photo
    @Binding var isPresented: Photo?
    @GestureState private var dragState = DragState.inactive
    
    private let dragThreshold: CGFloat = 150.0
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(uiImage: photo.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geometry.size.height * 0.8)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .offset(y: dragState.translation.height)
                    .gesture(
                        DragGesture()
                            .updating($dragState) { value, dragInfo, _ in
                                dragInfo = DragState(activeTranslation: value.translation)
                            }
                            .onEnded { value in
                                if value.translation.height > dragThreshold {
                                    isPresented = nil // Dismiss the full-screen view
                                }
                            }
                    )
                Spacer()
            }
            .animation(
                Animation
                    .easeInOut(duration: 1.5),
                value: UUID()
            )
        }
        .background(AnimatedBackground(colorSet: 1).blur(radius: 190))
        .statusBar(hidden: true)
    }
    
    private struct DragState {
        var activeTranslation: CGSize = .zero
        var translation: CGSize {
            activeTranslation
        }
        var isDraggingUp: Bool {
            activeTranslation.height < 0
        }
        static let inactive = DragState()
    }
}
/*
struct GalleryPage_Previews: PreviewProvider {
    static var previews: some View {
        GalleryPage()
    }
}
*/
