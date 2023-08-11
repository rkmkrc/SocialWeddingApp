//
//  MultiImagePicker.swift
//  WeddApp
//
//  Created by Erkam Karaca on 11.08.2023.
//

import Foundation
import SwiftUI

struct MultiImagePickerView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isPickerShowing = false

    var body: some View {
        NavigationView {
            VStack {
                Button("Select Images") {
                    self.isPickerShowing = true
                }
                
                // Display selected images
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                    }
                }
            }
            .navigationBarTitle("Multi Image Picker")
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePickerx(isPickerShowing: $isPickerShowing, selectedImages: $selectedImages)
        }
    }
}

struct MultiImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        MultiImagePickerView()
    }
}

struct ImagePickerx: UIViewControllerRepresentable {
    @Binding var isPickerShowing: Bool
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isPickerShowing {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = context.coordinator
            uiViewController.present(picker, animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinatorx {
        return Coordinatorx(self)
    }
    
    class Coordinatorx: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private var parent: ImagePickerx
        
        init(_ picker: ImagePickerx) {
            self.parent = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImages.append(image)
            }
            picker.dismiss(animated: true) {
                self.parent.isPickerShowing = false
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                self.parent.isPickerShowing = false
            }
        }
    }
}
